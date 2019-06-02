const path = require('path');

module.exports = {
    entry: {
        play: './src/play.bs.js',
        home: './src/home.bs.js'
    },
    output: {
        filename: '[name].js',
        path: path.resolve(__dirname, 'dist/javascripts'),
        libraryTarget: 'var',
        library: 'App'
    },

    mode: "development",

    devServer: {
        contentBase: path.join(__dirname, "app/dist"),
        compress: true,
        port: 9000
    }

};
