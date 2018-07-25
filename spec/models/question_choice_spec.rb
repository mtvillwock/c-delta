require 'rails_helper'

describe QuestionChoice do
  context 'associations' do
    it { is_expected.to belong_to(:question) }
    it { is_expected.to belong_to(:creative_quality) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :text }
    it { is_expected.to validate_presence_of :question }
    it { is_expected.to validate_presence_of :creative_quality }
    it { is_expected.to validate_numericality_of :score }
  end

  context 'convenience methods' do
    context '#text_class' do
      context 'when score is 0' do
        subject { create(:question_choice, score: 0) }
        it { is_expected.to eq "text-success" }
      end

      context 'when score is positive' do
        subject { create(:question_choice, score: 1) }
        it { is_expected.to eq "text-success" }
      end
      context 'when score is negative' do
        subject { create(:question_choice, score: -1) }
        it { is_expected.to eq "text-danger" }
      end
    end
  end
end
