ActiveAdmin.register Punch do
  index do
    column :user
    column :project, sortable: [:project, :name]
    column 'When', sortable: :from do |punch|
      l punch.from, format: '%d/%m/%Y'
    end
    column 'From' do |punch|
      l punch.from, format: '%H:%M'
    end
    column 'To' do |punch|
      l punch.to, format: '%H:%M'
    end
    column 'Delta' do |punch|
      "#{punch.delta} hs"
    end
    default_actions
  end

  controller do
    def permitted_params
      params.permit(punch: [:from, :to, :project_id])
    end
  end

  csv do
    column('User')    { |punch| punch.user.name }
    column('Project') { |punch| punch.project.name }
    column('When')    { |punch| l punch.from, format: '%d/%m/%Y' }
    column('From')    { |punch| l punch.from, format: '%H:%M' }
    column('To')      { |punch| l punch.to, format: '%H:%M' }
    column('Delta')   { |punch| "#{punch.delta}" }
  end

end