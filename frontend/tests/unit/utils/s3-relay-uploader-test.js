/* jshint expr:true */
import { expect } from 'chai';
import {
  describe,
  it,
  beforeEach,
  afterEach,
} from 'mocha';
import Pretender from 'pretender';
import S3RelayUploader from 'frontend/utils/s3-relay-uploader';

var uploader, file, fakeServer;

describe('S3RelayUploader', function() {
  beforeEach(function() {
    // fake file
    if (typeof WebKitBlobBuilder === 'undefined') {
      file = new Blob(['test'], { type: 'image/jpg' });
    } else {
      var builder = new WebKitBlobBuilder();
      builder.append('test');
      file = builder.getBlob();
    }
    file.mime = 'text/plain';
    file.name = 'test.txt';

    // stub api response
    var payload = {
      uuid:'fb07a85b-74bb-4197-b650-cd4b1b948acc',
      awsaccesskeyid:'ABCD',
    };
    fakeServer = new Pretender(function() {
      this.get('/s3_relay/uploads/new', function(request) {
        return [200, {"Content-Type": "application/json"}, JSON.stringify(payload)];
      });
    });
  });

  afterEach(function() {
    fakeServer.shutdown();
  });

  it('has upload url', function() {
    uploader = S3RelayUploader.create();
    expect(uploader.url).to.equal('/s3_relay/uploads/new');
  });

  it('uploads after signing', function() {
    var NewUploader = S3RelayUploader.extend({
      ajax: function() {
        expect(uploader).to.be.ok;
      }
    });
    uploader = NewUploader.create();
    uploader.upload(file);
  });
});