const winston = require.main.require('winston')
const Meta = require.main.require('./src/meta')
const Emailer = {}
const DMClientv2017 = require('@alicloud/dm-2017-06-22')
const DMClientv2015 = require('@alicloud/dm-2015-11-23')
let server
let accountName
Emailer.init = async function (params) {
  function render (req, res) {
    res.render('admin/plugins/emailer-aliyun-dm', {})
  }

  const settings = await Meta.settings.get('aliyun-dm')
  if (settings && settings.accessKeyId && settings.accessKeySecret && settings.accountName) {
    if (settings.endpoint && settings.endpoint !== 'https://dm.aliyuncs.com') {
      server = new DMClientv2017({
        endpoint: settings.endpoint,
        accessKeyId: settings.accessKeyId,
        accessKeySecret: settings.accessKeySecret
      })
    } else {
      server = new DMClientv2015({
        endpoint: 'https://dm.aliyuncs.com',
        accessKeyId: settings.accessKeyId,
        accessKeySecret: settings.accessKeySecret
      })
    }
    accountName = settings.accountName
  } else {
    winston.error('[plugins/emailer-aliyun-dm] 插件未配置！')
  }

  params.router.get('/admin/plugins/emailer-aliyun-dm', params.middleware.admin.buildHeader, render)
  params.router.get('/api/admin/plugins/emailer-aliyun-dm', render)
}

Emailer.send = async function (data) {
  if (!server) {
    winston.error('[emailer.aliyun-dm] 阿里云邮件推送服务尚未配置就绪！')
    return data
  }
  try {
    // console.log(data)
    await server.singleSendMail({
      AccountName: accountName,
      AddressType: 1,
      ReplyToAddress: true,
      ToAddress: data.to,
      Subject: data.subject,
      FromAlias: data.from_name,
      HtmlBody: data.html,
      TextBody: data.plaintext
    })
  } catch (err) {
    if (!err) {
      winston.verbose('[emailer.aliyun-dm] 发送 `' + data.template + '` 邮件给用户 ' + data.uid)
    } else {
      winston.warn('[emailer.aliyun-dm] 无法发送`' + data.template + '` 邮件给用户 ' + data.uid + '！！')
      winston.error('[emailer.aliyun-dm] (' + err.message + ')')
    }
    throw err
  }
}

Emailer.admin = {
  menu: async function (customHeader) {
    customHeader.plugins.push({
      'route': '/plugins/emailer-aliyun-dm',
      'icon': 'fa-envelope-o',
      'name': '发信服务（阿里云邮件推送）'
    })
    return customHeader
  }
}

module.exports = Emailer
