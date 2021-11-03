const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Popper: ['popper.js', 'default']
  })
)

environment.plugins.append('Provide', new webpack.ProvidePlugin({
  sweetalert2: 'sweetalert2/dist/sweetalert2.all',
  Swal: 'sweetalert2/dist/sweetalert2.all'
}));

module.exports = environment
