var poorParser = require('./poor-xml2json.js');

exports = module.exports = profile2json;

function profile2json(xmlFile, encoding, callback) {
    poorParser({
        source: {
            xmlFile: xmlFile,
            encoding: encoding
        },
        pseudoSample: require('./profile-pseudoSample.js').options
        /* no longer necessary - xml comes already filtered by language
        ,filter: function (tag) {
            // global filter on xml:lang
            var xml_lang = tag.attributes["xml:lang"];
            return (xml_lang === undefined || xml_lang === 'C' || xml_lang === this.own.lang);
        },
        own: {
            lang: lang
        }*/
    }, callback);
}
