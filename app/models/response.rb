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

  def question_choices
    question_responses.map(&:question_choice)
  end

  def choices_by_quality(quality)
    question_choices.
      select do |question_choice|
        question_choice if question_choice.creative_quality_id == quality.id
      end
  end

  def highest_choices_by_question(quality)
    question_responses.map do |question_response|
      question_choices = question_response. question.question_choices
      question_choices.by_quality(quality).by_high_score.first
    end.compact
  end

  def raw_score(quality)
    choices_by_quality(quality).sum(&:score)
  end

  def max_score(quality)
    highest_choices_by_question(quality).sum(&:score)
  end

  def self.total_raw_for(quality)
    raw_scores = Response.all.map do |response|
      response.raw_score(quality)
    end
    raw_scores.sum
  end

  def self.total_max_for(quality)
    max_scores = Response.all.map do |response|
      response.max_score(quality)
    end
    max_scores.sum
  end

  def self.normalized_score(quality)
    raw = total_raw_for(quality).to_f
    max = total_max_for(quality).to_f
    amount = ((raw / max) * 100)
    return amount.floor.to_i if amount > 100
    return amount.ceil.to_i if amount < -100
    amount.to_i
  end
end
