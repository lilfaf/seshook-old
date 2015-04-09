import Ember from 'ember';
import S3Uploader from 'ember-uploader/s3';

export default S3Uploader.extend({
  url: '/s3_relay/uploads/new',

  sign: function(file, data) {
    var self = this;
    var settings = {
      url: this.get('url'),
      headers: this.get('headers'),
      type: 'GET',
      contentType: 'json',
      data: data
    };

    return new Ember.RSVP.Promise(function(resolve, reject) {
      settings.success = function(data) {
        Ember.run(null, resolve, self.didSign(data));
      };
      settings.error = function(jqXHR, responseText, errorThrown) {
        Ember.run(null, reject, self.didError(jqXHR, responseText, errorThrown));
      };
      Ember.$.ajax(settings);
    });
  },

  setupFormData: function(file, data) {
    var formData = new FormData();
    formData.append("AWSAccessKeyID", data.awsaccesskeyid);
    formData.append("x-amz-server-side-encryption", data.x_amz_server_side_encryption);
    formData.append("key", data.key);
    formData.append("success_action_status", data.success_action_status);
    formData.append("acl", data.acl);
    formData.append("policy", data.policy);
    formData.append("signature", data.signature);
    formData.append("content-type", file.type);
    formData.append('content-disposition', 'inline; filename=\"' + file.name + '\"');
    formData.append("file", file);
    return formData;
  },

  upload: function(file, data) {
    var self = this;
    this.set('isUploading', true);

    return this.sign(file, data).then(function(data) {
      return self.ajax(data.endpoint, self.setupFormData(file, data));
    });
  }
});