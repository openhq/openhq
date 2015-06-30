// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require modernizr
//= require jquery
//= require jquery_ujs
//= require jquery.timeago
//= require s3_direct_upload
//= require jquery-ui
//= require chosen.jquery
//= require pickadate/picker
//= require pickadate/picker.date
//= require underscore
//= require turbolinks
//= require_self
//= require_tree ./features

var App = {
    onLoadFns: [],

    onPageLoad: function(callback) {
        this.onLoadFns.push(callback);
    },

    load: function() {
        _.each(this.onLoadFns, function(callback) {
            callback.call(this);
        }, this);
    }
};

$(document).ready(function() {

    Turbolinks.enableProgressBar();

    // Called everytime turbolinks loads a new page
    $(document).on("page:load", function() {
        App.load();
    });

    // Called on initial full page load
    _.defer(function() {
        App.load();
    });
});
