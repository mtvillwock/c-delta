require 'rails_helper'

describe Response do
  context 'associations' do
    it { is_expected.to have_many(:question_responses) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
  end

  describe '#display_name' do
    let(:response) { Response.new(first_name: 'Tal', last_name: 'Safran') }

    it 'concatenates the first and last name' do
      expect(response.display_name).to eql('Tal Safran')
    end
  end

  describe '#completed?' do
    let(:response) { Response.new }

    before do
      allow(Question).to receive(:count).and_return(3)
      allow(response).to receive_message_chain(:question_responses, :count)
        .and_return(response_count)
    end

    context 'when no responses exist' do
      let(:response_count) { 0 }
      it 'is false' do
        expect(response.completed?).to be(false)
      end
    end

    context 'when some responses exist' do
      let(:response_count) { 1 }
      it 'is false' do
        expect(response.completed?).to be(false)
      end
    end

    context 'when responses exist for all questions' do
      let(:response_count) { 3 }
      it 'is true' do
        expect(response.completed?).to be(true)
      end
    end
  end

  describe '#choices_by_quality' do
    let(:response) { Response.create!(first_name: "Test", last_name: "Case") }
    let(:question) { create(:question) }
    let(:creative_quality) { create(:creative_quality)}
    let(:question_choice) { create(:question_choice, creative_quality: creative_quality, question: question) }
    let(:question_response) { QuestionResponse.create!(response: response, question_choice: question_choice) }

    before do
      question.question_choices << question_choice
      response.question_responses << question_response
    end

    context 'when question responses have a question choice for a given creative quality' do

        subject { response.choices_by_quality(creative_quality) }

      it 'returns question choices for that creative quality' do
        expect(subject).to eq [question_choice]
      end
    end

    context 'when no question choices for creative quality' do
      let(:other_quality) { create(:creative_quality) }
      subject { response.choices_by_quality(other_quality) }
      it 'returns an empty array' do
        expect(subject).to be_empty
      end
    end
  end
end
