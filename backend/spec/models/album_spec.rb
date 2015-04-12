require 'rails_helper'

describe Album do
  ## DB schema ----------------------------------------------------------------

  it { is_expected.to have_db_column(:name).with_options(null: false) }
  it { is_expected.to have_db_column(:description) }
  it { is_expected.to have_db_column(:albumable_id) }
  it { is_expected.to have_db_column(:albumable_type) }
  it { is_expected.to have_db_column(:user_id) }

  it { is_expected.to have_db_index([:albumable_type, :albumable_id]) }
  it { is_expected.to have_db_index(:user_id) }

  ## Validations --------------------------------------------------------------

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:albumable_id) }

  ## Associations -------------------------------------------------------------

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:albumable) }
  it { is_expected.to have_many(:photos) }

  ## Concerns -----------------------------------------------------------------

  it_behaves_like 'temporal scopes'
  it_behaves_like 'photoable'
  it_behaves_like 'ransack searchable'
end
