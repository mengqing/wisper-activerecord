describe 'ActiveRecord' do
  let(:listener) { double('Listener') }

  before { Wisper::GlobalListeners.clear }

  describe 'create' do

    it 'publishes an created event to listener' do
      expect(listener).to receive(:meeting_created)
      Wisper::Activerecord.subscribe(Meeting, to: listener)

      Meeting.create!
    end

    it 'publishes created object to listener' do
      expect(listener).to receive(:meeting_created).with(an_instance_of(Meeting))
      Wisper::Activerecord.subscribe(Meeting, to: listener)

      Meeting.create!
    end

    it 'publishes an created failed event to listener if failed creation' do
      expect(listener).to receive(:meeting_create_failed)
      Wisper::Activerecord.subscribe(Meeting, to: listener)

      meeting = Meeting.new
      meeting.singleton_class.class_eval do
        attr_accessor :name
        validates_presence_of :name
      end

      meeting.save
    end

  end

  describe 'update' do
    before { Meeting.create! }

    it 'publishes an updated event to listener' do
      expect(listener).to receive(:meeting_updated)
      Wisper::Activerecord.subscribe(Meeting, to: listener)

      meeting = Meeting.first
      meeting.update_attributes(title: 'new title')

    end

    it 'publishes an update failed event to listener if failed update' do
      expect(listener).to receive(:meeting_update_failed)
      Wisper::Activerecord.subscribe(Meeting, to: listener)

      meeting = Meeting.first
      
      meeting.singleton_class.class_eval do
        attr_accessor :name
        validates_presence_of :name
      end

      meeting.update_attributes(title: 'new title')
    end
  end

  describe 'destroy' do
    before { Meeting.create! }

    it 'publishes a destroyed event to listener' do
      expect(listener).to receive(:meeting_destroyed)
      Wisper::Activerecord.subscribe(Meeting, to: listener)

      meeting = Meeting.first
      meeting.destroy

    end
  end
end
