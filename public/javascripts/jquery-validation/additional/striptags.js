/**
 * Custom avoid html tags to jquery.validate plugin
 * @todo Release a pull request to https://github.com/jzaefferer/jquery-validation
 * repository in future
 */
$.validator.addMethod('stripTags',function(value){

    var regex = /([\<])([^\>]{1,})*([\>])/i;
    return !regex.test(value);

},'HTML not be allowed!');

/**
 * @todo Move the default message to localization/messages_ptbr.js
 * and release a pull request to https://github.com/jzaefferer/jquery-validation
 * repository
 */
$.extend($.validator.messages, {
    stripTags: 'HTML não é permitido!'
});

$.validator.addClassRules('nohtml',{
    stripTags:true
});