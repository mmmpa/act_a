require 'rails_helper'

RSpec.describe ActA do
  let(:actor) { ActA.(Model) }

  describe 'validating with instance.valid?' do
    context 'when validated' do
      context 'with "validates"' do
        it { expect(actor.apply(str: '').valid_brutally?).to be_falsey }
        it { expect(actor.apply(str: '文字列').valid_brutally?).to be_truthy }
        it { expect(actor.apply(str: '文字列', txt: '').valid_brutally?).to be_falsey }
        it { expect(actor.apply(str: '文字列').valid_brutally?).to be_truthy }
      end

      context 'with other validate' do
        it { expect(actor.apply(str: '失敗する').valid_brutally?).to be_falsey }
      end
    end

    context 'when have error message' do
      it { expect(actor.apply(int: '文字列').validate_brutally.messages[:int]).to include('number only') }
      it { expect(actor.apply(int: '文字列').validate_brutally.errors.messages[:int]).to include('number only') }
    end

    context 'when use !' do
      it { expect{actor.apply(str: '文字列', txt: '').validate_brutally!}.to raise_exception(ActiveRecord::RecordInvalid) }
    end

    context 'with self made validator' do
      it { expect(actor.apply(bol: '文字列').valid_brutally?).to be_falsey }
      it { expect(actor.apply(bol: true).valid_brutally?).to be_truthy }
    end
  end

  describe 'validating with duplicated validator' do
    context 'when validated' do
      context 'with "validates"' do
        it { expect(actor.apply(str: '').valid?).to be_falsey }
        it { expect(actor.apply(str: '文字列').valid?).to be_truthy }
        it { expect(actor.apply(str: '文字列', txt: '').valid?).to be_falsey }
        it { expect(actor.apply(str: '文字列').valid?).to be_truthy }
      end

      context 'with other validate' do
        it { expect(actor.apply(str: '失敗する').valid?).to be_truthy }
      end

      context 'with self made validator' do
        it { expect(actor.apply(bol: '文字列').valid?).to be_falsey }
      end

      context 'when have error message' do
        it { expect(actor.apply(int: '文字列').validate.messages[:int]).to include('number only') }
        it { expect(actor.apply(int: '文字列').validate.errors.messages[:int]).to include('number only') }
      end

      context 'when use !' do
        it { expect{actor.apply(str: '文字列', txt: '').validate!}.to raise_exception(ActiveRecord::RecordInvalid) }
      end

      context 'with self made validator' do
        it { expect(actor.apply(bol: '文字列').valid?).to be_falsey }
        it { expect(actor.apply(bol: true).valid?).to be_truthy }
      end
    end
  end
end
