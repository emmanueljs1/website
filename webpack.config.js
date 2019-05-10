const path = require('path');

module.exports = {
    entry: './ml/game.bs.js',
    output: {
        filename: 'game.js',
        path: path.resolve(__dirname, 'public/javascripts'),
        libraryTarget: 'var',
        library: 'App'
    },
    mode: "development",

    devServer: {
        contentBase: path.join(__dirname, "dist"),
        compress: true,
        port: 9000
    }

};
