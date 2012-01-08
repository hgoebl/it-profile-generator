var wordwrap = require('wordwrap'),
    _ = require('underscore');

/**
 * Wordwrap for multiple columns.
 * @param {Array} colwidths array with the width of each column (element type should be convertible to Number)
 * @param {Array} texts array with the text of each column (element types can be string or array)
 * @param {Number} [distance = 1] the number of spaces between columns
 */
function wrapMultiColumn(colwidths, texts, distance) {

    var colwrappers, cols, filler, i, lines,
        distance = distance || 1;

    // create a wordwrapper for each column
    colwrappers = _(colwidths).map(function (width) {
        return wordwrap(width);
    });

    // wrap each column to an array of single column lines
    cols = _.map(colwrappers, function (wrap, col) {
        var text = col >= texts.length ? '' : texts[col];
        if (_.isArray(text)) {
            text = text.join('\n');
        }
        text = wrap(text);

        return text.split(/\n/);
    });

    // one string to fill columns shorter than their col-width
    filler = new Array(_.max(colwidths) + 1 + distance).join(' ');

    // find maximum count of lines
    var lineCount = _.reduce(cols, function (max, col) {
        return max > col.length ? max : col.length;
    }, 0);

    lines = [];
    // will iterate line by line (some of the cols won't have values in each line)
    for (i = 0; i < lineCount; ++i) {
        lines.push(_(colwidths).map(
            function (width, col) {
                var linesOfCol = cols[col],
                    lineOfCol = i < linesOfCol.length ? linesOfCol[i] : '';

                if (col < colwidths.length - 1) {
                    lineOfCol += filler.substring(0, width - lineOfCol.length + distance);
                }
                return lineOfCol;
            }).join(''));
    }

    return lines.join('\n');
}

module.exports = wrapMultiColumn;
