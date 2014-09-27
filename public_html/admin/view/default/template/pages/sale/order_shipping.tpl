<?php if (!empty($error['warning'])) { ?>
	<div class="warning alert alert-error alert-danger"><?php echo $error['warning']; ?></div>
<?php } ?>
<?php if ($success) { ?>
	<div class="success alert alert-success"><?php echo $success; ?></div>
<?php } ?>

<?php echo $summary_form; ?>

<?php echo $order_tabs ?>
<div class="tab-content">

	<div class="panel-heading">

		<div class="pull-right">
			<div class="btn-group mr10 toolbar">
				<a class="btn btn-white tooltips" target="_invoice" href="<?php echo $invoice_url; ?>" data-toggle="tooltip"
				   title="<?php echo $text_invoice; ?>" data-original-title="<?php echo $text_invoice; ?>">
					<i class="fa fa-file-text"></i>
				</a>
				<?php if (!empty ($help_url)) : ?>
					<a class="btn btn-white tooltips" href="<?php echo $help_url; ?>" target="new" data-toggle="tooltip"
					   title="" data-original-title="Help">
						<i class="fa fa-question-circle fa-lg"></i>
					</a>
				<?php endif; ?>
			</div>

			<?php echo $form_language_switch; ?>
		</div>

	</div>

	<?php echo $form['form_open']; ?>
	<div class="panel-body panel-body-nopadding">

		<label class="h4 heading"><?php echo $edit_title_shipping; ?></label>
		<?php foreach ($form['fields'] as $name => $field) { ?>
		<?php
		//Logic to cululate fileds width
		$widthcasses = "col-sm-7";
		if (is_int(stripos($field->style, 'large-field'))) {
			$widthcasses = "col-sm-7";
		} else if (is_int(stripos($field->style, 'medium-field')) || is_int(stripos($field->style, 'date'))) {
			$widthcasses = "col-sm-5";
		} else if (is_int(stripos($field->style, 'small-field')) || is_int(stripos($field->style, 'btn_switch'))) {
			$widthcasses = "col-sm-3";
		} else if (is_int(stripos($field->style, 'tiny-field'))) {
			$widthcasses = "col-sm-2";
		}
		$widthcasses .= " col-xs-12";
		?>
		<div class="form-group <? if (!empty($error[$name])) {
			echo "has-error";
		} ?>">
			<label class="control-label col-sm-3 col-xs-12"
				   for="<?php echo $field->element_id; ?>"><?php echo ${'entry_' . $name}; ?></label>

			<div class="input-group afield <?php echo $widthcasses; ?> <?php echo($name == 'description' ? 'ml_ckeditor' : '') ?>">
				<?php echo $field; ?>
			</div>
			<?php if (!empty($error[$name])) { ?>
				<span class="help-block field_err"><?php echo $error[$name]; ?></span>
			<?php } ?>
		</div>
		<?php } ?><!-- <div class="fieldset"> -->
	</div>


	<div class="panel-footer">
		<div class="row center">
			<div class="col-sm-6 col-sm-offset-3">
				<button class="btn btn-primary">
					<i class="fa fa-save"></i> <?php echo $form['submit']->text; ?>
				</button>
				&nbsp;
				<a class="btn btn-default" href="<?php echo $cancel; ?>">
					<i class="fa fa-refresh"></i> <?php echo $form['cancel']->text; ?>
				</a>
			</div>
		</div>
	</div>

	</form>
</div><!-- <div class="tab-content"> -->


<script type="text/javascript"><!--
	jQuery(function ($) {

		getZones = function (country_id) {
			if (!country_id) {
				country_id = '<?php echo $shipping_country_id; ?>';
			}

			$.ajax(
					{
						url: '<?php echo $common_zone; ?>&country_id=' + country_id + '&zone_id=<?php echo $shipping_zone_id; ?>&type=shipping_zone',
						type: 'GET',
						dataType: 'json',
						success: function (data) {
							result = data;
							showZones(data);
						}
					});
		}

		showZones = function (data) {
			var options = '';

			$.each(data['options'], function (i, opt) {
				options += '<option value="' + i + '"';
				if (opt.selected) {
					options += 'selected="selected"';
				}
				options += '>' + opt.value + '</option>'
			});

			var selectObj = $('#orderFrm_shipping_zone_id');

			selectObj.html(options);
			var selected_name = $('#orderFrm_shipping_zone_id :selected').text();
			selectObj.parent().find('span').text(selected_name);
			selectObj.after('<input id="shipping_zone_name" name="shipping_zone" value="' + selected_name + '" type="hidden" />');

		}

		getZones();

		$('#orderFrm_shipping_zone_id').on('change', function () {
			$('#shipping_zone_name').val($('#shipping_zone select :selected').text());
		});

		$('#orderFrm_shipping_country_id').change(function () {
			getZones($(this).val());
			$('#shipping_zone select').aform({triggerChanged: false})

		});


		$('#orderFrm').submit(function () {
			$('input[name="shipping_country"]', this).val($('#shipping_country option:selected').text());
			$('input[name="shipping_zone"]', this).val($('#shipping_zone select option:selected').text());
		});
	});
	-->
</script>