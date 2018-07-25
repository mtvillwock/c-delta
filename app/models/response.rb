class Response < ApplicationRecord
  has_many :question_responses

  validates :first_name, presence: true
  validates :last_name, presence: true

  delegate :count, to: :question_responses, prefix: true

  def display_name
    "#{first_name} #{last_name}"
  end

  def completed?
    question_responses_count == Question.count
  end

  def choices_by_quality(quality)
    question_responses.
      map(&:question_choice).
      select do |question_choice|
        question_choice if question_choice.creative_quality_id == quality.id
      end
  end

  def total_raw_score(quality)
    choices_by_quality.sum(&:score)
  end

  def total_max_score(quality)

  end

  def normalized_score(quality)
    (total_raw_for_quality / total_max_for_quality) * 100
  end
end
