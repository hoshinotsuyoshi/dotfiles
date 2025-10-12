require 'set'
require 'shellwords'

def home
  @home ||= ENV['HOME'] || abort('Error. Set env `HOME`')
end

def xdg_config_home
  "#{home}/.config"
end

def xdg_data_home
  "#{home}/.local/share"
end

def ghq_dir
  "#{xdg_data_home}/go/src"
end

def xdg_state_home
  "#{home}/.local/state"
end

def red_puts(string)
  print "\e[31m"
  puts string
  print "\e[0m"
end

def which(string)
  sh "which #{string}"
end

def ghq_get(string)
  sh "ghq get #{string} || true"
end

def port_check(string)
  sh "#{['port', 'installed', string].shelljoin} | #{['grep', '-q', string].shelljoin}"
end

def check_directory_entries(dir_path, allowlist)
  unless Dir.exist?(dir_path)
    red_puts "Error: #{dir_path} does not exist"
    abort
  end

  entries = Set.new(Dir.children(dir_path))
  unexpected = entries - allowlist

  if unexpected.empty?
    puts "✅ No unexpected entries under #{dir_path}"
  else
    red_puts '🚨 Unexpected entries found:'
    unexpected.sort.each { |name| puts "  - #{name}" }
    abort 'Unexpected entries exist. Please clean up or update allowlist.'
  end
end

# Common helper for rm with backup
def rm_with_backup!(*target_args, rm_method:, cp_method:)
  [*target_args].each do |target_path|
    abort "cannot rm relative_path: #{target_path}" unless target_path.start_with?('/')
  end

  backup_base = "/tmp/dotfiles_backup/"
  mkdir_p backup_base
  [*target_args].each do |target_path|
    next unless File.exist?(target_path)
    backup_path = File.join(backup_base, target_path)

    mkdir_p File.dirname(backup_path)
    send(rm_method, backup_path)
    send(cp_method, target_path, backup_path)
  end
  send(rm_method, *target_args)
end

# rm_rf with backup
def rm_rf!(*target_args)
  rm_with_backup!(*target_args, rm_method: :rm_rf, cp_method: :cp_r)
end

# rm_f with backup
def rm_f!(*target_args)
  rm_with_backup!(*target_args, rm_method: :rm_f, cp_method: :cp)
end

desc "default task"
task default: :main

task main: [
  # alacritty
  :ln_alacritty_files,

  # misc
  :check_fzf,
  :check_ghq,
  :check_z,

  # tmux
  :check_tmux,
  :check_reattach_to_user_namespace,
  :ln_tmux_files,

  # mise
  :check_mise,
  :ln_mise_files,

  # git
  :ln_git_files,

  # gh
  :check_gh,
  :ln_gh_files,

  # irb
  :ln_irb_files,

  # bundler
  :ln_bundler_files,

  # direnv
  :check_direnv,

  # zsh
  :ln_zshenv,
  :ln_zsh_files,

  # less
  :setup_less_dir,

  # neovim
  :check_neovim,
  :ln_nvim_files,
  :rbenv_ruby_build,

  # check
  :check_home_entries,
  :check_config_entries,

  # last message
  :success,
]


task :check_macports do
  which 'port'
rescue => e
  red_puts 'error!'
  red_puts 'Install MacPorts. visit https://www.macports.org'
  abort e.to_s
end

task check_fzf: :check_macports do
  which 'fzf'
rescue => e
  red_puts 'error!'
  red_puts 'Do $ sudo port install fzf'
  abort e.to_s
end

task check_ghq: :check_go do
  which 'ghq'
rescue => e
  red_puts 'error!'
  red_puts 'Do $ go install github.com/x-motemen/ghq@v1.4.2'
  abort e.to_s
end

task check_go: :check_macports do
  which 'go'
rescue => e
  red_puts 'error!'
  red_puts 'Do $ sudo port install go'
  abort e.to_s
end

task check_z: [:check_ghq, "#{ghq_dir}/github.com/rupa/z/z.sh"]
file "#{ghq_dir}/github.com/rupa/z/z.sh" do
  ghq_get 'github.com/rupa/z'
end


# ---- Link tasks ----------------------------------------------------

task :ln_alacritty_files do
  mkdir_p xdg_config_home
  target = "#{xdg_config_home}/alacritty"
  rm_rf! target
  ln_sf File.expand_path('config/alacritty'), target
end

task :ln_tmux_files do
  mkdir_p xdg_config_home
  target = "#{xdg_config_home}/tmux"
  rm_rf! target
  ln_sf File.expand_path('config/tmux'), target
end

task :ln_git_files do
  mkdir_p "#{xdg_config_home}/git"
  target = "#{xdg_config_home}/git"
  rm_rf! "#{target}/config"
  rm_rf! "#{target}/ignore"
  ln_sf File.expand_path('config/git/config'), "#{target}/config"
  ln_sf File.expand_path('config/git/ignore'), "#{target}/ignore"

  # Link config.private and config.office for includeIf
  rm_rf! "#{target}/config.private"
  rm_rf! "#{target}/config.office"
  ln_sf File.expand_path('config/git/config.private'), "#{target}/config.private"
  ln_sf File.expand_path('config/git/config.office'), "#{target}/config.office"

  rm_rf! "#{target}/template"
  ln_sf File.expand_path('config/git/template'), "#{target}/template"
end

task :ln_zshenv do
  rm_f! "#{home}/.zshenv"
  ln_sf File.expand_path('.zshenv'), "#{home}/.zshenv"
end

task :ln_zsh_files do
  mkdir_p "#{xdg_config_home}/zsh"
  target = "#{xdg_config_home}/zsh"
  rm_rf! "#{target}/.zsh.d"
  rm_f!  "#{target}/.zshrc"
  rm_f!  "#{target}/.zshenv"
  rm_f!  "#{target}/.zprofile"

  ln_sf File.expand_path('config/zsh/.zshrc'), "#{target}/.zshrc"
  ln_sf File.expand_path('config/zsh/.zshenv'), "#{target}/.zshenv"
  ln_sf File.expand_path('config/zsh/.zprofile'), "#{target}/.zprofile"
  ln_sf File.expand_path('config/zsh/.zsh.d'), "#{target}/.zsh.d"
end

task :ln_nvim_files do
  mkdir_p xdg_config_home
  target = "#{xdg_config_home}/nvim"
  rm_rf! target
  ln_sf File.expand_path('config/nvim'), target
end

task :ln_gh_files do
  mkdir_p xdg_config_home
  target = "#{xdg_config_home}/gh"
  rm_rf! target
  ln_sf File.expand_path('config/gh'), target
end

task :ln_mise_files do
  mkdir_p xdg_config_home
  target = "#{xdg_config_home}/mise"
  rm_rf! target
  ln_sf File.expand_path('config/mise'), target
end

task :ln_irb_files do
  mkdir_p xdg_config_home
  target = "#{xdg_config_home}/irb"
  rm_rf! target
  ln_sf File.expand_path('config/irb'), target
end

task :ln_bundler_files do
  mkdir_p xdg_config_home
  target = "#{xdg_config_home}/bundler"
  rm_rf! target
  ln_sf File.expand_path('config/bundler'), target
end

task :setup_less_dir do
  mkdir_p "#{xdg_state_home}/less"
end

# ---- Check tasks -------------------------------------------------------

task check_tmux: [:check_macports] do
  which 'tmux'
rescue
  red_puts 'error!'
  red_puts 'Do $ sudo port install tmux'
  abort
end

task check_reattach_to_user_namespace: :check_tmux do
  which 'reattach-to-user-namespace'
rescue
  red_puts 'error!'
  red_puts 'Do $ sudo port install tmux-pasteboard'
  abort
end

task check_mise: [:check_macports] do
  which 'mise'
rescue
  red_puts 'error!'
  red_puts 'Do $ sudo port install mise'
  abort
end

task check_direnv: :check_macports do
  which 'direnv'
rescue
  red_puts 'error!'
  red_puts 'Do $ sudo port install direnv'
  abort
end

task check_neovim: :check_macports do
  which 'nvim'
rescue
  red_puts 'error!'
  red_puts 'Do $ sudo port install neovim'
  abort
end

task check_gh: :check_macports do
  which 'gh'
rescue
  red_puts 'error!'
  red_puts 'Do $ sudo port install gh'
  abort
end

task check_iceberg: [:check_ghq, '/opt/local/share/nvim/runtime/colors/iceberg.vim']
file '/opt/local/share/nvim/runtime/colors/iceberg.vim' do
  ghq_get 'github.com/cocopon/iceberg.vim'
  sh "sudo ln -fs #{ghq_dir}/github.com/cocopon/iceberg.vim/colors/iceberg.vim /opt/local/share/nvim/runtime/colors/iceberg.vim"
end

task rbenv: "#{ghq_dir}/github.com/rbenv/rbenv"
directory "#{ghq_dir}/github.com/rbenv/rbenv" do
  ghq_get 'github.com/rbenv/rbenv'
end

task rbenv_ruby_build: [:rbenv, "#{ghq_dir}/github.com/rbenv/ruby-build"]
directory "#{ghq_dir}/github.com/rbenv/ruby-build" do
  ghq_get 'github.com/rbenv/ruby-build'
  mkdir_p "#{xdg_data_home}/rbenv/plugins"
  unless File.exist?("#{xdg_data_home}/rbenv/plugins/ruby-build")
    ln_sf "#{ghq_dir}/github.com/rbenv/ruby-build", "#{xdg_data_home}/rbenv/plugins"
  end
end

task :check_home_entries do
  allowlist = Set.new(%w[
    .CFUserTextEncoding
    .DS_Store
    .Trash
    .aws
    .cache
    .claude
    .claude.json
    .claude.json.backup
    .config
    .docker
    .gnupg
    .local
    .npm
    .serena
    .ssh
    .tmux.conf
    .vscode
    .z
    .zshenv
    Applications
    Desktop
    Documents
    Downloads
    Library
    Movies
    Music
    Pictures
    Public
  ])

  check_directory_entries(home, allowlist)
end

task :check_config_entries do
  allowlist = Set.new(%w[
    alacritty
    bundler
    gh
    git
    irb
    mise
    nvim
    rbenv
    tmux
    zed
    zsh
  ])

  check_directory_entries(xdg_config_home, allowlist)
end

task :success do
  puts
  puts '✅ success!'
end
