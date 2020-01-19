<h1><i class="fa fa-envelope-o"></i> 发信服务（阿里云邮件推送）</h1>

<div class="row">
	<div class="col-lg-12">
		<blockquote>
			<p>
				阿里云邮件推送是阿里云提供的类似 Mailgun 的邮件发送平台。本插件使用阿里云邮件推送的 API 方式发信，能够规避服务器 IP 暴露的问题。
			</p>
		</blockquote>
		<p>
			开始使用：
		</p>
		<ol>
			<li>
				注册一个<a href="https://aliyun.com" target="_blank">阿里云</a>账户。 然后启用它的<a href="https://www.aliyun.com/product/directmail?spm=a2c4g.11174283.2.1.4f6c5e7aJNXs2h" target="_blank">邮件推送服务</a>，它为新用户提供每日 200 封邮件的免费配额。如果你的发信质量提升的话，他会提高的你免费配额。
			</li>
			<li>
				新增一个<a href="https://usercenter.console.aliyun.com/manage/ak" target="_blank">权限账户</a>，赋予它使用邮件推送服务的权力。保存它的 AccessKeyID 以及 AccessKeySecret，填写在下方。
			</li>
			<li>
				配置好你的邮件推送服务，记住配置好的发信邮箱，填写在下方。
			</li>
			<li>
				（可选）如果你的服务器位于国外，在<a href="https://help.aliyun.com/document_detail/96856.html" target="_blank">文档</a>中找到离你服务器最近的 Host 然后将其填写在下方的配置中的 Endpoint 中（记得带上 https://）。
			</li>
		</ol>
	</div>
</div>

<hr />

<form role="form" class="emailer-settings">
	<fieldset>
		<div class="row">
			<div class="col-sm-6">
				<div class="form-group">
					<label for="accessKeyId">accessKeyId</label>
					<input type="text" class="form-control" id="accessKeyId" name="accessKeyId" placeholder="填写 accessKeyId"/>
				</div>
			</div>
			<div class="col-sm-6">
				<div class="form-group">
					<label for="domain">accessKeySecret</label>
					<input type="text" class="form-control" id="accessKeySecret" name="accessKeySecret" placeholder="填写 accessKeySecret"/>
				</div>
			</div>
			<div class="col-sm-6">
				<div class="form-group">
					<label for="domain">endpoint</label>
					<input type="text" class="form-control" id="endpoint" name="endpoint" placeholder="填写 EndPoint（可选）" />
				</div>
			</div>
			<div class="col-sm-6">
				<div class="form-group">
					<label for="domain">AccountName</label>
					<input type="text" class="form-control" id="accountName" name="accountName" placeholder="填写配置的发信邮箱地址。" />
				</div>
			</div>
		</div>

		<button class="btn btn-lg btn-primary" id="save" type="button">保存</button>
	</fieldset>
</form>
<br />
<br />
<script type="text/javascript">
	require(['settings'], function(Settings) {
		Settings.load('aliyun-dm', $('.emailer-settings'));

		$('#save').on('click', function() {
			Settings.save('aliyun-dm', $('.emailer-settings'), function() {
				app.alert({
					type: 'success',
					alert_id: 'aliyun-dm-saved',
					title: '配置已保存',
					message: '点击此处以重启你的 NodeBB ，使配置生效。',
					timeout: 2500,
					clickfn: function() {
						socket.emit('admin.reload');
					}
				});
			});
		});
	});
</script>
