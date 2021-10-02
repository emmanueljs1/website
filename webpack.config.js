const path = require('path');

module.exports = {
    entry: {
        play: './src/play.bs.js',
        home: './src/home.bs.js'
    },
    output: {
        filename: '[name].js',
        path: path.resolve(__dirname, 'app/public/javascripts'),
        libraryTarget: 'var',
        library: 'App'
    },

    mode: "development",

    devServer: {
        static: {
            contentBase: path.join(__dirname, "app/dist")
        },
        port: 9000
    }

};
