class CreateMetricsEventsForVisitor < ActiveRecord::Migration
  def change
    create_table :metrics_events do |t|
      t.string :name
      t.integer :originator_id
      t.string :originator_type
      t.string :event_type
      t.timestamps
    end

    create_table :visitors do |t|
      t.string :name
      t.timestamps
    end
  end
end
