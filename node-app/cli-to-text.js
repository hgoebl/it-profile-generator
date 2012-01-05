var fs = require('fs'),
    profile2Text = require('./lib/profile-to-text.js'),
    profile,
    colwidths,
    distance,
    output,
    argv = require('optimist')
        .usage('Usage: $0 [options] <input-json> <output-text>')
        .demand(2)
        .options('colwidths', {
            'default': '18,75',
            describe: 'widths of columns'
        })
        .options('encoding', {
            'default': 'utf8',
            alias: 'e',
            describe: 'character encoding of text file'
        })
        .options('distance', {
            'default': '1',
            describe: '# of spaces between cols'
        })
        .argv;


profile = JSON.parse(fs.readFileSync(argv._[0], 'utf8')).profile;
colwidths = JSON.parse('[' + argv.colwidths + ']');
distance = Number(argv.distance);

output = profile2Text(profile, colwidths, distance);

fs.writeFile(argv._[1], output, argv.encoding);
