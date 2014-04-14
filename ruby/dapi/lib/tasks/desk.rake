
namespace :desk do

  task :client => :environment do
    api = Desk.new
    parsed = api.get_cases
    puts "\n---\nget_cases: #{parsed.class.name}\n#{JSON.pretty_generate(parsed)}\n"

    parsed = api.get_case(1)
    puts "\n---\nget_case 1: #{parsed.class.name}\n#{JSON.pretty_generate(parsed)}\n"

    parsed = api.get_labels
    puts "\n---\nget_labels: #{parsed.class.name}\n#{JSON.pretty_generate(parsed)}\n"

    parsed = api.get_label(1730082)
    puts "\n---\nget_label 1730082: #{parsed.class.name}\n#{JSON.pretty_generate(parsed)}\n"
  end

end
