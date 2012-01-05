var profile = {};

Ext.require([
    'Ext.Button',
    'Ext.tab.Panel',
    'Ext.MessageBox',
    'Ext.LoadMask',
    'Ext.navigation.View']);

Ext.define('Goebl.contact', {
    extend: 'Ext.form.Panel',
    alias: 'widget.contactpanel',
    layout: 'vbox',
    config: {
        mask: {
            xtype: 'loadmask',
            message: 'Please wait ...',
            hidden: true
        },
        items: [
            {
                xtype: 'fieldset',
                title: 'Contact Me',
                instructions: '(email address is optional)',
                items: [
                    {
                        xtype: 'textfield',
                        name: 'name',
                        label: 'Name'
                    },
                    {
                        xtype: 'emailfield',
                        name: 'email',
                        label: 'Email'
                    },
                    {
                        xtype: 'textareafield',
                        name: 'message',
                        label: 'Message'
                    },
                    {
                        xtype: 'textfield',
                        name: 'sum',
                        label: '17 + 4 ='
                    }
                ]
            },
            {
                xtype: 'button',
                text: 'Send',
                ui: 'confirm',
                handler: function () {
                    console.log('send pressed');
                    var formpanel = this.up('formpanel'),
                        values = formpanel.getValues();
                    console.log(values);
                    formpanel.mask('Sending...');
                    Ext.Ajax.request({
                        url: 'contact.php',
                        method: 'POST',
                        timeout: 20000,
                        jsonData: values,
                        success: function (response, options) {
                            var respObj;
                            formpanel.unmask();
                            respObj = Ext.decode(response.responseText);
                            Ext.Msg.alert(respObj.success ? 'Info' : 'Warning', respObj.message, Ext.emptyFn);
                        },
                        failure: function (response, options) {
                            formpanel.unmask();
                            Ext.Msg.alert('Error', 'Sending mail failed. Please try again later.', Ext.emptyFn);
                        }
                    });
                }
            }
        ]
    },
    initComponents: function () {
        //this.myMask = new Ext.LoadMask(Ext.getBody(), {msg: "Please wait..."});
    }
});

Ext.application({
    name: 'Goebl',

    viewport: {
        layout: 'fit'
    },

    launch: function () {
        Ext.Ajax.request({
            url: '../profil/hgoebl.de.json',
            method: 'GET',
            success: function (response) {
                console.log(response);
                profile = Ext.decode(response.responseText);
                if (profile.profile) {
                    profile = profile.profile;
                }
            },
            failure: function (response) {
                Ext.Msg.alert('Error',
                    'Currently there is a problem getting data from the server. Please try again later.', Ext.emptyFn);
            }
        });
        Ext.Viewport.add({
            xtype: 'tabpanel',
            fullscreen: true,
            tabBarPosition: 'bottom',
            items: [
                {
                    title: 'Home',
                    iconCls: 'home',
                    cls: 'home',
                    id: 'home',
                    html: [
                        '<h1>Welcome!</h1>',
                        '<br/>',
                        '<img width="65%" src="img/logo.gif" />'
                    ].join('')
                },
                {
                    title: 'Profile',
                    iconCls: 'user',
                    xtype: 'navigationview',
                    useTitleForBackButtonText: true,
                    id: 'profile',
                    padding: 10,
                    items: (function () {
                        var data = [
                            {title: 'Personal Data'},
                            {title: 'Photo'},
                            {title: 'Qualifications'},
                            {title: 'Technical Profile'},
                            {title: 'Work Experience'}
                        ];
                        var buttons = Ext.Array.map(data, function (item) {
                            return {
                                xtype: 'button',
                                text: item.title,
                                handler: function () {
                                    var view = Ext.getCmp('profile');
                                    /*
                                     //use the push() method to push another view. It works much like
                                     //add() or setActiveItem(). it accepts a view instance, or you can give it
                                     //a view config.
                                     */
                                     view.push({
                                     title: 'Second',
                                     html: 'Second view!'
                                     });
                                }
                            }
                        });

                        return {
                            title: 'Profile',
                            items: buttons
                        };
                    })()
                },
                {
                    title: 'Contact',
                    iconCls: 'compose',
                    xtype: 'contactpanel'
                },
                {
                    title: 'Imprint',
                    iconCls: 'info',
                    cls: 'home',
                    html: [
                        '<h1>Imprint</h1>'
                    ].join('')
                }
            ]
        });
    }
});
