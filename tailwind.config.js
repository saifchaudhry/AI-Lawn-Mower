module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        'greenpal': {
          'blue': '#0EA5E9',
          'orange': '#F97316', 
          'green': '#22C55E',
          'dark-blue': '#0369A1'
        }
      }
    }
  },
  plugins: []
}
