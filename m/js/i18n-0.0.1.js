/**
 * i18n - an object dealing with internationalization, translation and accept-language parsing
 * (C) 2011 Heinrich Göbl
 * MIT Licensed
 */
"use strict";

var i18n = {
    fallbackLanguage: 'en',
    languages: [],
    translation: {},

    parseAcceptLanguage: function (acceptLanguage) {
        acceptLanguage = acceptLanguage || this.fallbackLanguage;
        var re = /^([a-z]{1,8}(-[a-z]{1,8})?)\s*(;\s*q\s*=\s*(1|0\.[0-9]+))?$/i,
            parts, matches, i, len,
            languages = [];

        parts = acceptLanguage.split(',');
        for (i = 0, len = parts.length; i < len; ++i) {
            matches = re.exec(parts[i].replace(/^\s+/, '').replace(/\s+$/, ''));
            if (matches) {
                languages.push({
                    lang: matches[1].toLowerCase(),
                    q: Number(matches[4] ? matches[4] : '1')
                });
            }
        }

        languages.sort(function (a, b) { // order matches by q desc
            return b.q - a.q;
        });
        this.languages = languages;

        return languages;
    },

    selectLanguage: function (available) {
        // we only take the first 2 characters of the language (en-US -> en)
        var lang, i, len,
            availStr = '',
            languages = this.languages;

        for (i = 0, len = available.length; i < len; ++i) {
            availStr += available[i].substring(0, 2).toLowerCase();
            availStr += '|';
        }
        for (i = 0, len = languages.length; i < len; ++i) {
            lang = languages[i].lang.substring(0, 2).toLowerCase();
            if (availStr.indexOf(lang + '|') >= 0) {
                this.lang = lang;
                return lang;
            }
        }
        // language not found in accept-language -> take first of available languages
        lang = this.lang = availStr.substring(0, 2);
        return lang;
    },

    get: function (key) {
        var value = this.translation[key];
        // for debug purposes use this block instead
        // return value ? value : 'NOT DEFINED: ' + key;
        return value ? value : key;
    },

    getLang: function () {
        var lang = this.get('lang');
        return lang === 'lang' ? this.fallbackLanguage : lang;
    }
};
