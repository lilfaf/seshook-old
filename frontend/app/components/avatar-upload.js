import Ember from 'ember';
import S3RelayUploader from '../utils/s3-relay-uploader';
import FileField from 'ember-uploader/file-field';

export default FileField.extend({
  url: '/s3_relay/uploads',
  uuid: null,
  contentType: null,
  filename: null,

  filesDidChange: (function() {
    var self = this;
    var file = this.get('files')[0];
    var uploader = S3RelayUploader.create();

    uploader.on('progress', function(e) {
      Ember.Logger.debug('Progress: ' + e.percent);
    });

    uploader.on('didSign', function(response) {
      self.set('uuid', response.uuid);
    });

    uploader.on('didUpload', function(response) {
      self.saveUpload(response);
    });

    uploader.on('didError', function(error) {
      Ember.Logger.debug(error);
    });

    if (!Ember.isEmpty(file)) {
      this.set('contentType', file.type);
      this.set('filename', file.name);

      uploader.upload(file);
    }
  }).observes('files'),

  saveUpload: function(response) {
    var self = this;

    var uploadedUrl = Ember.$(response).find('Location')[0].textContent;
    uploadedUrl = decodeURIComponent(uploadedUrl);

    Ember.$.ajax({
      url: self.get('url'),
      type: 'POST',
      dataType: 'json',
      data: {
        public_url: uploadedUrl,
        parent_type: 'user',
        parent_id: self.get('session.user_id'),
        content_type: self.get('contentType'),
        uuid: self.get('uuid'),
        filename: self.get('filename'),
        association: 'AvatarUpload',
      },
      success: function(data) {
        Ember.Logger.debug('Yay! Saved to backend successfully!');
        Ember.Logger.debug(data);
      },
      error: function(xhr) {
        Ember.Logger.debug(xhr.responseText);
      }
    });
  }
});
