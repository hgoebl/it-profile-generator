var _ = require('underscore');

/**
 Generates a vCard from profile data.
 <br>
 http://en.wikipedia.org/wiki/VCard
 */
function profile2vCard(profile) {

    var person,
        out = [];

    function output(field, values) {
        if (_.isArray(values)) {
            values = values.join(';');
        }
        out.push([ field, values ].join(':'));
    }

    person = profile.person;

    out.push('BEGIN:VCARD');
    output('FN',
        _([
            person.title,
            person.firstName,
            person.middleName,
            person.lastName,
            person.suffix
        ]).compact().join(' '));
    output('N',
        [
            person.lastName,
            person.firstName,
            person.middleName,
            person.title,
            person.suffix
        ]);
    output('ADR',
        [
            '', // ?
            '', // ?
            person.street,
            person.city,
            person.state,
            person.zip,
            person.country
        ]);
    _(person.telephone).each(function (item) {
        item = item.replace(/[^+0-9]/g, ''); // c14n of telephone number
        output('TEL', item);
    });
    _(person.email).each(function (item) {
        output('EMAIL', item);
    });
    _(person.web).each(function (item) {
        output('URL', item);
    });
    output('VERSION', '3.0');
    out.push('END:VCARD');

    return out.join('\n');
}

module.exports = profile2vCard;
