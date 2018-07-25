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

  describe '#text_class' do
    context 'when score is 0' do
      subject { build_stubbed(:question_choice, score: 0).text_class }
      it { is_expected.to eq "text-success" }
    end

    context 'when score is positive' do
      subject { build_stubbed(:question_choice, score: 1).text_class }
      it { is_expected.to eq "text-success" }
    end
    context 'when score is negative' do
      subject { build_stubbed(:question_choice, score: -1).text_class }
      it { is_expected.to eq "text-danger" }
    end
  end

  describe '.by_quality' do
    let(:creative_quality) { create(:creative_quality)}
    let(:other_quality) { create(:creative_quality) }
    let(:choice_1) { create(:question_choice, creative_quality: creative_quality)}
    let(:choice_2) { create(:question_choice, creative_quality: other_quality)}
    subject { QuestionChoice.by_quality(creative_quality) }

    it 'returns question choices for the given creative quality' do
      expect(subject).to include choice_1
      expect(subject).to_not include choice_2
    end
  end

  describe '.by_high_score' do
    let(:scores) { [1,2,3] }
    before do
      scores.each { |num| create(:question_choice, score: num) }
    end
    it 'returns question choices ordered by highest to lowest score' do
      QuestionChoice.by_high_score.each_with_index do |item, index|
        expect(item.score).to eq scores.reverse[index]
      end
    end
  end
end
