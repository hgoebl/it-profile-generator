var sax = require("sax"),
    fs = require("fs"),
    _ = require("underscore");

exports = module.exports = poorXml2Json;

/**
 * Parses some XML into a JavaScript object
 * @param options
 * <pre>{
 *     source: {
 *         // exactly one of xmlFile | xmlString | binary
 *         xmlFile: '/home/I/file.xml',
 *         xmlString: '<?xml version="1.0" encoding="utf8"?><root><child attr="value"/></root>",
 *         binary: data,
 *         [encoding: 'utf8' // only necessary when binary has no prologue and encoding != utf8]
 *     },
 *     sax: {
 *         // see https://github.com/isaacs/sax-js
 *     },
 *     pseudoSample: {
 *         // see README.md
 *     },
 *     filter: function (tag, context) {
 *         // filter is a function, when provided, returns false for elements which should be skipped
 *         return !tag.attributes['xml:lang'] === this.own.lang;
 *     },
 *     own: {
 *         // namespace for application specific options;
 *         // could be accessed in the filter function
 *         lang: 'en' // just an example
 *     }
 * }
 * </pre>
 * @param callback
 */
function poorXml2Json(options, callback) { // exported
    var error, xmlString;

    error = validateOptions(options);
    if (error) {
        callback(error);
        return;
    }

    if (options.source.xmlFile) {
        fs.readFile(options.source.xmlFile, function (error, data) {
            if (error) {
                callback(error);
            }
            var xmlString = data.toString(options.source.encoding || 'utf8');
            parse(xmlString, options, callback);
        });
    }
    else if (option.source.xmlString) {
        xmlString = option.source.xmlString;
        parse(xmlString, options, callback);
    }
    else {
        xmlString = option.source.binary.toString(options.source.encoding || 'utf8');
        parse(xmlString, options, callback);
    }
}

function validateOptions(options) {
    if (! _(options).isObject()) {
        return new Error('option parameter must be an object');
    }
    if (! _(options.source).isObject()) {
        return new Error('options parameter is missing "source" property');
    }
    var sourceCount = 0;
    if (options.source.xmlFile) ++sourceCount;
    if (options.source.binary) ++sourceCount;
    if (options.source.xmlString) ++sourceCount;
    if (sourceCount !== 1) {
        return new Error('exactly one of "xmlFile", "binary" or "xmlString" must be given in "source" property');
    }
    return undefined;
}

function findOption(parentOption, tagName) {
    if (!parentOption) {
        return null;
    }
    var options = parentOption[tagName];
    if (options !== undefined) {
        return options;
    }
    return parentOption["<default>"];
}

function parse(xmlString, options, callback) {

    var parser = sax.parser(true, options.sax || {trim: true, normalize: true}),
        context = [{ tag: null, options: options.pseudoSample, output: {}}];

    parser.onerror = function (error) {
        callback(error);
    };

    parser.onprocessinginstruction = function (name, body) {
        if (name === "xml" && options.source.encoding) {
            var match = body.match(/encoding\s*=\s*['"]([A-Za-z_0-9-]+)['"]/);
            if (match) {
                if (options.source.encoding.toUpperCase() !== match[1].toUpperCase()) {
                    callback(new Error('Encoding doesn\'t match;' +
                        ' stream: ' + match[1] + ' option: ' + options.source.encoding));
                    // TODO parser.stop() ???
                }
            }
        }
    };

    parser.onopentag = function (tag) {
        var parent = _(context).last();
        var tagName = tag.name;
        var current = {
            tag: tagName,
            options: findOption(parent.options, tagName)
        };
        context.push(current);

        // check if element should be skipped
        if (!current.options) {
            return;
        }

        if (_(options.filter).isFunction()) {
            if (!options.filter.call(options, tag, context)) {
                current.options = false;
                return;
            }
        }

        // translate native options element to more accessible
        if (_.isArray(current.options)) {
            if (parent.output[tagName] === undefined) {
                parent.output[tagName] = [];
            }
            current.options = current.options[0]; // array is only a 'marker'
            current.array = true;
        }

        if (_.isString(current.options)) {
            if (current.options === "text") {
                // always collect the text from this node locally in output-array
                current.output = [];
                current.text = true;
            }
            else {
                console.warn('unknown option ' + current.options, _.pluck(context, 'tagName'));
            }
        }
        else if (_.isObject(current.options)) {
            current.output = {};
        }
        else {
            console.warn('unknown config option', current.options, _.pluck(context, 'tagName'));
        }
    };

    parser.onclosetag = function (tagName) {
        var current, parentCtx, nodeObject;

        current = context.pop();
        if (!current.options) {
            return; // element ignored
        }

        if (current.text) {
            nodeObject = current.output.join(' ');
        }
        else {
            nodeObject = current.output;
        }

        parentCtx = _(context).last();
        if (current.array) {
            parentCtx.output[tagName].push(nodeObject);
        }
        else {
            parentCtx.output[tagName] = nodeObject;
        }
    };

    parser.ontext = function (text) {
        var current = _(context).last();
        if (!current.options) {
            return;
        }
        if (current.text) {
            text = text.replace(/\s{2,}/g, ' ').trim();
            current.output.push(text);
        }
    };

    parser.onend = function () {
        callback(null, context[0].output);
    };

    parser.write(xmlString).end();
}
