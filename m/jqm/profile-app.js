// requires: jQuery, i18n, Mustache
// TODO requires variable: $SERVER_HTTP_ACCEPT_LANGUAGE

/**
 * Constructor function for the profile app.
 * <br/>
 * Only stores the values for later use - no loading yet.
 * @param options
 * @param {String} options.name the (case-sensitive) name of the profile
 * @param {String} options.relativeProfilePath the base path for the profiles.
 *                 Must be on the same host and port -> relativley addressed.
 * @param {String} options.lang the default language code if the preferred
 *                 language of the user (browser) cannot be computed.
 * @param {String} options.availableLanguages the available language codes.
 *                 These are the languages supported by this CV/profile.
 */
function ProfileApp(options) {
    var defaults = {
        relativeProfilePath: '../../profiles',
        contactUrl: '../php/contact.php',
        name: 'sample-multilang'
        // TODO lang: 'en'
    };
    $.extend(this, defaults, options);
    /* TODO remove
    if (!this.availableLanguages) {
        this.availableLanguages = [ this.lang ];
    }*/

    this.profile = {};
}

ProfileApp.renderContent = function (templateId, data, target) {
    var html = Mustache.to_html($('#' + templateId).html(), data);
    if (target) {
        $(target).html(html);
    }
    return html;
};

/**
 * Loads the profile and the i18n translation data (depending on some factors).
 * @param {String} [lang] language - if provided, this language is forced to load, otherwise the best language
 *                        is chosen by Apache httpd mod_negotiation (Accept-Language header).
 * @param {Function} callback the callback function (err) which is called after success and failure.
 */
ProfileApp.prototype.load = function (lang, callback) {
    var self = this;
    if (typeof lang === 'function') {
        callback = lang; // shift arguments
        lang = undefined;
    }

    var profileLink,
        contentLink,
        i18nLink,
        tasksRunning = 3,
        readyHandler = function () {
            if (--tasksRunning <= 0) {
                callback(null);
            }
        };

    profileLink = Mustache.to_html('{{relativeProfilePath}}/{{name}}/{{name}}.json', self);
    contentLink = Mustache.to_html('{{relativeProfilePath}}/{{name}}/mobile-content.xml', self);
    i18nLink = '../data/i18n.json';

    if (lang) {
        profileLink += '.' + lang;
        contentLink += '.' + lang;
        i18nLink += '.' + lang;
    }

    $.getJSON(i18nLink, null, function (data, status) {
        if (status !== 'success') {
            callback('Unable to load translation data.');
            return;
        }
        i18n.translation = data;
        $('[data-i18n]').text(function () {
            var key = $(this).attr('data-i18n');
            return i18n.get(key);
        });
        readyHandler();
    });

    $.getJSON(profileLink, null, function (data, status) {
        if (status !== 'success') {
            callback('Unable to load necessary profile data.');
            return;
        }
        self.profile = data.profile;
        $(['personal_data', 'qualifications', 'skills', 'projects']).each(function () {
            ProfileApp.renderContent('tmpl-' + this, self.profile, "#" + this + " :jqmData(role='content')")
        });
        var person = self.profile.person,
            photo = person.photo_hires || person.photo_lowres,
            src;
        if (photo) {
            if (/^https?:\/\/.*/.test(photo)) {
                src = photo;
            }
            else {
                src = [self.relativeProfilePath, self.name, photo].join('/');
            }
            $('#div-photo').html($('<img>').attr({
                src: src,
                alt: [i18n.get('Photo of'), person.firstName, person.lastName].join(' '),
                width: '100%'
            }));
        }
        readyHandler();
    });

    $.ajax({
        url: contentLink,
        dataType: 'html',
        success: function (data) {
            $("#about div[data-role='content']").html(data);
            readyHandler();
        },
        error: function () {
            callback('Unable to load additional content data.');
        }
    });
};

ProfileApp.showMessageBox = function (level, message) {
    var $alert = $('#alert'),
        header, theme;

    switch (level) {
        case 'info':
            header = i18n.get('Info');
            theme = 'a';
            break;
        case 'warn':
            header = i18n.get('Warning');
            theme = 'e';
            break;
        default:
            header = i18n.get('Error');
            theme = 'e';
            break;
    }
    $alert.attr('data-theme', theme);
    $alert.find('header h1').text(header);
    $alert.find('div[data-role="content"] p:first').html(message);

    $('#tmpl-alert-link').find('a').click();
};

ProfileApp.prototype.submitContactForm = function () {
    var self = this,
        query = $('#submitContactBtn').closest('form').serializeArray(),
        json = {};

    $.each(query, function (i, nameValue) {
        json[nameValue.name] = nameValue.value;
    });

    // console.log('submitting to ' + self.contactUrl, json);

    $.mobile.showPageLoadingMsg();
    $.ajax({
        url: self.contactUrl,
        type: 'POST',
        data: JSON.stringify(json),
        contentType: 'application/json',
        dataType: 'json',
        timeout: 20000,
        error: function (/*jqXHR, textStatus, errorThrown*/) {
            $.mobile.hidePageLoadingMsg();
            ProfileApp.showMessageBox('error', i18n.get('Unable to send message.'));
        },
        success: function (data /*, textStatus*/) {
            $.mobile.hidePageLoadingMsg();
            if (data.success === true) {
                ProfileApp.showMessageBox('info', i18n.get('Message sent successfully.'));
            }
            else {
                ProfileApp.showMessageBox('warn', i18n.get(data.code));
            }
        }
    });
    return false;
};

var profileApp = new ProfileApp({
    name: (function (window, undefined) {
        var profileName = window.location.search;
        return (/^\?[a-zA-Z_0-9-]+$/.test(profileName)) ? profileName.substring(1) : undefined;
    })(window)
});

$(function () {
    var footer = $('#tmpl-footer').html();
    $("section[data-id='myfooter']").each(function () {
        var $section = $(this), btnActiveHref;

        $section.append(footer);

        btnActiveHref = $section.attr('data-nojqm-btn-active');
        if (btnActiveHref) {
            $section.find("a[href='" + btnActiveHref + "']").addClass('ui-btn-active');
        }
    });

    $('#submitContactBtn').click(function () {
        profileApp.submitContactForm();
    });
});

$('#home').live('pagebeforecreate', function (/*event*/) {

    /* TODO remove?
    if (typeof $SERVER_HTTP_ACCEPT_LANGUAGE !== 'string') {
        alert('Programming/Configuration error; $SERVER_HTTP_ACCEPT_LANGUAGE not set!');
        return;
    }*/

    // i18n.parseAcceptLanguage($SERVER_HTTP_ACCEPT_LANGUAGE);
    // bestLang = i18n.selectLanguage(profileApp.availableLanguages);

    $.mobile.showPageLoadingMsg();
    profileApp.load(function () {
        $.mobile.hidePageLoadingMsg();
        $.mobile.loadingMessage = i18n.get('Loading ...');
    });

    $(document).ajaxError(function (event, request, settings) {
        $.mobile.hidePageLoadingMsg();
        ProfileApp.showMessageBox('error', i18n.get('Error requesting ') + settings.url);
    });
});
