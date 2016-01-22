angular.module 'WFMS.WorkflowDevelopmentApplication'
.config ($mdThemingProvider) ->

  $mdThemingProvider.definePalette('wfm', {"50":"#d2d9e7","100":"#a1afcc","200":"#7d90b8","300":"#546a9a","400":"#495d86","500":"#3e4f72","600":"#33415e","700":"#28344a","800":"#1e2637","900":"#131823","A100":"#d2d9e7","A200":"#a1afcc","A400":"#495d86","A700":"#28344a"});

  $mdThemingProvider.definePalette 'workflowPalette',
    50: 'ffebee'
    100: 'ffcdd2'
    200: 'ef9a9a'
    300: 'e57373'
    400: 'ef5350'
    500: '3E4F72'
    600: 'e53935'
    700: 'd32f2f'
    800: 'c62828'
    900: 'b71c1c'
    A100: 'ff8a80'
    A200: 'ff5252'
    A400: 'ff1744'
    A700: 'd50000'
    contrastDefaultColor: 'dark'
    contrastDarkColors: ['50', '100', '200', '300', '400', 'A100']
    contrastLightColors: undefined

  $mdThemingProvider.theme('wfm_theme').dark().primaryPalette('wfm').accentPalette('wfm')
