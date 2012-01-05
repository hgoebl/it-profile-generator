var fs = require('fs'),
    xml2js = require('xml2js'),
    _ = require('underscore'),
    util = require('util');

var parser = new xml2js.Parser();

exports = module.exports = i18n2json;

function i18n2json(xmlFile, callback) {

    fs.readFile(xmlFile, function (err, data) {
        if (err) {
            console.warn(err);
            callback(err);
            return;
        }
        parser.parseString(data, function (error, result) {
            if (error) {
                callback(error);
            }
            callback(null, convertFromRaw(result));
        });
    });
}

function convertFromRaw(raw) {
    var key, out = {};

    _(raw.entry).each(function (entry) {
        var key = entry['@']['key'],
            msgs = entry.msg;

        if (!_(msgs).isArray()) {
            msgs = [msgs];
        }
        _(msgs).each(function (msg) {
            var lang = msg['@']['xml:lang'];
            if (out[lang] === undefined) {
                out[lang] = {};
            }
            out[lang][key] = msg['#'];
        });
    });

    return out;
}
