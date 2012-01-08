var fs = require('fs'),
    path = require('path'),
    _ = require('underscore'),
    Mustache = require('mustache'),
    wrapMultiColumn = require('./wrap-multi-column.js');

function profile2Text(profile, colwidths, distance) {

    var lang = profile.lang,
        person,
        out = [],
        trans;

    trans = {
        map: (function (lang) {
            var i18nFile = path.resolve(__dirname, '../../m/data/i18n.json.{{lang}}'.replace('{{lang}}', lang));
            try {
                return JSON.parse(fs.readFileSync(i18nFile));
            } catch (e) {
                console.warn('Unable to read translation file for language ' + lang, e);
                return {};
            }
        }(lang)),

        get: function (key) {
            var value = this.map[key];
            return value ? value : key;
        }
    };

    function nl() {
        out.push('');
    }

    function outputHeader(header, isFirstLine) {
        if (isFirstLine !== true) {
            out.push('');
        }
        out.push(header);
        out.push(new Array(header.length + 1).join('='));
        out.push('');
    }

    function output(col1, col2) {
        if (typeof col2 === 'undefined') {
            return;
        }
        if (typeof col2 === 'string' && col2.trim().length === 0) {
            return;
        }
        out.push(wrapMultiColumn(colwidths, [ col1, col2 ], distance));
    }

    person = profile.person;

    outputHeader(trans.get('Personal Details / Overview'), true);

    output(trans.get('Name'),
        _([
            person.title,
            person.firstName,
            person.middleName,
            person.lastName,
            person.suffix
        ]).compact().join(' '));

    output(trans.get('Address'),
        [
            person.street,
            Mustache.to_html(trans.get('{{city}} {{state}} {{zip}}'), person),
            person.country
        ]
    );
    output(trans.get('Date of birth'), person.dateOfBirth);
    output(trans.get('workingSince'), person.workingSince);
    output(trans.get('Telephone'), person.telephone);
    output(trans.get('E-Mail'), person.email);
    output(trans.get('Internet'), person.web);
    nl();
    output(trans.get('Languages'), person.languages.language);
    output(trans.get('qualifications'), person.qualifications.education);
    output(trans.get('Core Area'), person.coreArea);
    output(trans.get('Area of work'), person.areaOfWork);

    outputHeader(trans.get('Competencies'));
    _(profile.competencies).each(function (value, key) {
        output(trans.get(key), value);
    });

    outputHeader(trans.get('Work experience'));

    profile.workExperience.project.forEach(function (project) {
        output(project.period,
            _.compact(_.flatten([
                [ project.companyOrLine, project.line1info ].join(' '),
                project.activities
            ])));
        output(trans.get('Roles'), project.roles);
        output(trans.get('Software'), project.software);
        out.push(''); // newline
        out.push(''); // newline
    });

    return out.join('\n');
}

module.exports = profile2Text;
