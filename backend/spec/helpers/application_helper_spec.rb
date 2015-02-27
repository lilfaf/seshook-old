require 'rails_helper'

describe ApplicationHelper do
  describe "#bootstrap_class_for" do
    it { expect(helper.bootstrap_class_for('success')).to eq('alert-success') }
    it { expect(helper.bootstrap_class_for('error')).to eq('alert-danger') }
    it { expect(helper.bootstrap_class_for('alert')).to eq('alert-warning') }
    it { expect(helper.bootstrap_class_for('notice')).to eq('alert-info') }
  end
end
