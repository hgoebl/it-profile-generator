var fs = require('fs'),
    profile2vCard = require('./lib/profile-to-vcard.js'),
    profile,
    output,
    argv = require('optimist')
        .usage('Usage: $0 [options] <input-json> <output-vcf>')
        .demand(2)
        .argv;


profile = JSON.parse(fs.readFileSync(argv._[0], 'utf8')).profile;

output = profile2vCard(profile);

fs.writeFileSync(argv._[1], output, argv.encoding);
