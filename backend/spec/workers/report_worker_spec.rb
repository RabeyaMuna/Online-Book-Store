require 'rails_helper'

RSpec.describe ReportWorker do
  let(:instance) { described_class.new }
  let!(:user) { FactoryBot.create(:user) }
  let(:perform) { instance.perform(user) }

  describe 'when mail creation is successful' do
    it 'queues the job' do
      expect(perform.job_id).not_to be_nil
      expect(perform.queue_name).to eq('default')
    end
  end
end
