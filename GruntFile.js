/**
 * Grunt Module
 */

module.exports = function (grunt) {
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        /**
        * Set project object
        */
        project: {
            basedir: '.',
            themedir: '../bert',
            theme: {
                css: '<%= project.themedir %>/dev/css',
                js: '<%= project.themedir %>/dev/js',
                scss: '<%= project.themedir %>/src/scss',
            },
            bert: {
                scss: '../bert/src/scss'
            },
            src: {
                scss: '<%= project.basedir %>/src/scss',
                js: '<%= project.basedir %>/js',
            },
            dist: {
                css: '<%= project.basedir %>/dist/css',
                scss: '<%= project.basedir %>/dist/scss',
                js: '<%= project.basedir %>/dist/js',
            },
            dev: {
                css: '<%= project.basedir %>/dev/css',
                scss: '<%= project.basedir %>/dev/scss',
                js: '<%= project.basedir %>/dev/js',
            },
            test: {
                basedir: '<%= project.basedir %>/test',
                port: 8020,
                livereload: 8021
            }
        },
        clean: {
            dev: {
                src: [ '<%= project.dev %>/*' ]
            },
            dist: {
                src: [ '<%= project.dist %>/*' ]
            }
        },
        /**
        * Project banner
        */
        banner: '/*!\n' +
            ' * UAS Homepage CSS\n' +
            ' * <%= pkg.url %>\n' +
            ' * @author <%= pkg.author %>\n' +
            ' * @version <%= pkg.version %>, compiled ' + (new Date()).toUTCString() + '\n' +
            ' * Copyright <%= pkg.copyright %>. For licensing information, see <%= pkg.repository.license %>.\n' +
            ' */\n'
        ,
        usebanner: {
            dist: {
                options: {
                    replace: true,
                    position: 'top',
                    banner: '<%= banner %>'
                },
                files: {
                    src: [ '<%= project.basedir %>/dist/css/*.css' ]
                }
            },
        },
        /**
        * Sass
        */
        sass: {
            dev: {
                options: {
                    precision: 8,
                    style: 'expanded',
                    loadPath: [
                        '<%= project.src.scss %>/dev',
                        '<%= project.theme.scss %>/dev',
                        '<%= project.theme.scss %>'
                    ]
                },
                files: [
                    {
                    expand: true,
                    cwd: '<%= project.src.scss %>/',
                    src: ['**/*.scss'],
                    dest: '<%= project.dev.css %>/',
                    ext: '.css',
                    extDot: 'first'
                    }
                ]
            },
            dist: {
                options: {
                    style: 'compressed',
                    loadPath: [
                        '<%= project.src.scss %>/dist',
                        '<%= project.theme.scss %>/dist',
                        '<%= project.theme.scss %>'
                    ]
                },
                files: [
                    {
                    expand: true,
                    cwd: '<%= project.src.scss %>/',
                    src: ['**/*.scss'],
                    dest: '<%= project.dist.css %>/',
                    ext: '.css',
                    extDot: 'first'
                    }
                ]
            }
        },
        /**
        * Watch
        */
        watch: {
            css: {
                files: [ '<%= project.src.scss %>/**/*.scss' ],
                tasks: ['sass:dev', 'sass:dist', 'postcss:dist'],
            },
            livereload: {
                options: {
                    livereload: '<%= project.test.livereload %>'
                },
                files: [
                    '<%= project.basedir %>/test/*.html',
                    '<%= project.basedir %>/test/*.js',
                    '<%= project.basedir %>/test/*.css',
                ]
            }
        },
        postcss: {
            options: {
                processors: [
                    // add fallbacks for rem units
                    require('pixrem')(),
                    // add vendor prefixes - list defined in package.json variable browserslist
                    require('autoprefixer')(),
                    // minify the result
                    require('cssnano')()
                ]
            },
            dist: {
                src: '<%= project.dist.css %>/**/*.css'
            },
            dev: {
                src: '<%= project.dev.css %>/**/*.css'
            }
        },
        connect: {
            server: {
                options: {
                    base: ['<%= project.test.basedir %>'],
                    port: '<%= project.test.port %>',
                    middleware: function(connect, options, middlewares) {
                        var connectSSI = require('connect-ssi');

                        if (!Array.isArray(options.base)) {
                            options.base = [options.base];
                        }
                        var directory = options.directory || options.base[options.base.length - 1];

                        middlewares.unshift(connectSSI({
                            baseDir: directory,
                            ext: '.html'
                        }));
                        return middlewares;
                    },
                    livereload: '<%= project.test.livereload %>',
                    open: {
                        target: 'http://localhost:' + '<%= project.test.port %>',
                        appName: 'open',
                        callback: function() {}
                    }
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-postcss');
    grunt.loadNpmTasks('grunt-contrib-connect');
    grunt.loadNpmTasks('grunt-banner');

    grunt.registerTask('printConfig', function() {
        grunt.log.writeln(JSON.stringify(grunt.config(), null, 2));
    });

 /**
 * Default task
 * Run `grunt` on the command line
 */
    grunt.registerTask('default', [
        'connect', 'watch'
    ]);
    grunt.registerTask('compile', [
        'sass:dev', 'sass:dist', 'postcss:dist', 'usebanner:dist'
    ]);
}
