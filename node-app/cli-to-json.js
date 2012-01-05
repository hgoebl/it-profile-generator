var fs = require("fs"),
    profile2json = require('./lib/profile-to-json.js'),
    argv = require('optimist')
        .usage('Usage: $0 [options] <input-xml> <output-json>')
        .demand(2)
        .options('encoding', {
            'default': 'utf8',
            alias: 'e',
            describe: 'character encoding of xml file'
        })
        .options('space', {
            'default': '0',
            describe: 'indentation for output json (0 = minimized)'
        })
        .argv;

profile2json(argv._[0], argv.encoding, function (error, obj) {
    var space = Number(argv.space);
    fs.writeFile(argv._[1], JSON.stringify(obj, null, space), function (err) {
        if (err) {
            console.log(err);
        }
    });
});