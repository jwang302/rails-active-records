class Profile < ApplicationRecord
  belongs_to :user
  validates :gender, acceptance: { accept: %w[male female] }

  validate :last_name_or_first_name_present, :male_named_sue

  def last_name_or_first_name_present
    if first_name.nil? && last_name.nil?
      errors.add(:name, 'first_name and last_name cannot both be nil')
    end
  end

  def male_named_sue
    errors.add(:first_name, 'Sue cannot be male') if first_name == 'Sue' && gender == 'male'
  end

  def self.get_all_profiles(min_year, max_year)
    Profile
      .where('birth_year BETWEEN ? AND ?', min_year, max_year)
      .order(:birth_year)
  end
end
