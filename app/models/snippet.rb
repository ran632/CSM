class Snippet < ActiveRecord::Base
  belongs_to :user

  enum privacy_setting: [:_public, :_private]
end
