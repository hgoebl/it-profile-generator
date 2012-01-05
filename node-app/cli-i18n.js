var fs = require("fs"),
    _ = require("underscore"),
    i18n_to_json = require('./lib/i18n-to-json.js'),
    async = require('async'),
    argv = require('optimist')
        .usage('Usage: $0 [options] <i18n-xml> <output-dir>')
        .demand(2)
        .options('space', { 'default': '0' })
        .argv;

i18n_to_json(argv._[0], function (error, obj) {

    if (error) {
        console.warn('error while converting i18n', error);
        process.exit(1);
    }

    var languages = _(obj).keys();
    fs.writeFileSync(argv._[1] + '/supported-languages.txt', languages.join('\n') + '\n', 'utf8');

    async.forEachLimit(languages, 4,
        function (lang, callback) {
            var fileName = argv._[1] + '/i18n.json.' + lang,
                space = Number(argv.space);

            fs.writeFile(fileName, JSON.stringify(obj[lang], null, space), callback);
        },
        function (error) {
            if (error) {
                console.log(error);
                process.exit(1);
            }
        });
});
