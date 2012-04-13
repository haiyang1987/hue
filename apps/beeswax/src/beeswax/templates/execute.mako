## Licensed to Cloudera, Inc. under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  Cloudera, Inc. licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
<%!
  from desktop.lib.django_util import extract_field_data
  from desktop.views import commonheader, commonfooter
%>

<%namespace name="comps" file="beeswax_components.mako" />
<%namespace name="layout" file="layout.mako" />
<%namespace name="util" file="util.mako" />

<%def name="query()">

		<fieldset>
			% if design and not design.is_auto and design.name:
		          <legend>${design.name}</legend>
		          % if design.desc:
		            <p>${design.desc}</p>
		          % endif

		      % else:
		        <legend>Query</legend>
		      % endif

          <div class="clearfix">
            <div class="input">
              	<textarea class="span9" rows="9" placeholder="Example: SELECT * FROM tablename" name="${form.query["query"].html_name | n}" id="queryField">${extract_field_data(form.query["query"]) or ''}</textarea>
				<div id="validationResults">
				% if len(form.query["query"].errors):
					${unicode(form.query["query"].errors) | n}
				 % endif
				</div>
            </div>
          </div>
        </fieldset>



		<div class="actions">
			<a id="executeQuery" class="btn primary">Execute</a>
			% if design and not design.is_auto and design.name:
            <a id="saveQuery" class="btn">Save</a>
          	% endif
          	<a id="saveQueryAs" class="btn">Save as...</a>

			<a id="explainQuery" class="btn">Explain</a>
			&nbsp; or <a href="${ url('beeswax.views.execute_query') }">create a new query</a>
		</div>




 <!--
<a href="#settings">see the advanced settings</a>
    <div>
      ${comps.field(form.saveform['name'])}
      ${comps.field(form.saveform['desc'])}
    </div>
-->
</%def>


${commonheader("Hive Query", "beeswax", "100px")}
${layout.menubar(section='query')}
<div class="container-fluid">

	<h1>Hive Query</h1>

	<div class="row-fluid">
		<div class="span3">
			<div class="well sidebar-nav">
				<ul class="nav nav-list">
					<li class="nav-header"></li>
					<li><a href="#"></a></li>
				</ul>
				<form id="advancedSettingsForm" action="${action}" method="POST" class="form-stacked noPadding">
					<h4>Advanced settings</h4>
					<h6>Hive settings</h6>
					% for i, f in enumerate(form.settings.forms):
					% if i > 0:
						<hr/>
					% endif

					<div class="clearfix">
						${comps.label(f['key'])}
						<div class="input">
							${comps.field(f['key'], attrs=dict(
								placeholder="mapred.reduce.tasks",
								klass="span3 settingsField"
							))}
						</div>
					</div>

					<div class="clearfix">
						${comps.label(f['value'])}
						<div class="input">
							${comps.field(f['value'], attrs=dict(
								placeholder="1",
								klass="span3"
							))}
						</div>
					</div>
					<div class="clearfix">
						${comps.field(f['_deleted'], tag="button", button_text="Remove", notitle=True, attrs=dict(
							type="submit",
							title="Delete this setting",
							klass="btn small btn-danger settingsDelete"
						), value=True)}
					</div>
					${comps.field(f['_exists'], hidden=True)}
				    % endfor
					<div class="clearfix">
						<a class="btn small" data-form-prefix="settings">Add</a>
					</div>


					<h6>File Resources</h6>
					 % for i, f in enumerate(form.file_resources.forms):
			              % if i > 0:
			                <hr/>
			              % endif

						<div class="clearfix">
							${comps.label(f['type'])}
							<div class="input">
								${comps.field(f['type'], render_default=True, attrs=dict(
									klass="span3"
								))}
							</div>
						</div>

						<div class="clearfix">
							${comps.label(f['path'])}
							<div class="input">
								${comps.field(f['path'], attrs=dict(
									placeholder="/user/foo/udf.jar",
									klass="span3 file_resourcesField"
								))}
							</div>
						</div>
						<div class="clearfix">
							<a href="#" data-filechooser-destination="${f['path'].html_name | n}" class="btn small">Choose a File</a>

							${comps.field(f['_deleted'], tag="button", button_text="Remove", notitle=True, attrs=dict(
								type="submit",
								title="Delete this setting",
								klass="btn small danger file_resourcesDelete"
							), value=True)}

							${comps.field(f['_exists'], hidden=True)}
						</div>
			            % endfor
						<div class="clearfix">
							<a class="btn small" data-form-prefix="file_resources">Add</a>
						</div>

					<h6>User-defined Functions</h6>
					% for i, f in enumerate(form.functions.forms):
			          % if i > 0:
			            <hr/>
			          % endif

						<div class="clearfix">
							${comps.label(f['name'])}
							<div class="input">
								${comps.field(f['name'], attrs=dict(
									placeholder="myFunction",
									klass="span3 functionsField"
								))}
							</div>
						</div>
						<div class="clearfix">
							${comps.label(f['class_name'])}
							<div class="input">
								${comps.field(f['class_name'], attrs=dict(
									placeholder="com.acme.example",
									klass="span3"
								))}
							</div>
						</div>

			    		<div class="clearfix">
							${comps.field(f['_deleted'], tag="button", button_text="Remove", notitle=True, attrs=dict(
								type="submit",
								title="Delete this setting",
								klass="btn small danger"
							), value=True)}
						</div>

			          ${comps.field(f['_exists'], hidden=True)}
			        % endfor
					<div class="clearfix">
						<a class="btn small" data-form-prefix="functions">Add</a>
					</div>

					<h6>Parametrization</h6>
					${comps.field(form.query["is_parameterized"],
			            notitle = True,
			            tag = "checkbox",
			            button_text = "Enable Parameterization",
			            help = "If checked (the default), you can include parameters like $parameter_name in your query, and users will be prompted for a value when the query is run.",
			            help_attrs= dict(
			              data_help_direction='11'
			            )
			        )}
					<h6>Email Notification</h6>
					${comps.field(form.query["email_notify"],
			                      notitle = True,
			                      tag = "checkbox",
			                      button_text = "Email me on complete",
			                      help = "If checked, you will receive an email notification when the query completes.",
			                      help_attrs= dict(
			                        data_help_direction='11'
			                      )
			                     )}
					<input type="hidden" name="${form.query["query"].html_name | n}" class="query" value="" />
				</form>
			</div>
		</div>
		<div class="span9">
			% if error_message:
				<div class="alert alert-error">
					<p><strong>Your Query Has the Following Error(s):</strong></p>
					<p>${error_message}</p>
					% if log:
						<small>click the <b>Error Log</b> tab below for details</small>
					% endif
				</div>
			% endif

	        % if on_success_url:
	          <input type="hidden" name="on_success_url" value="${on_success_url}"/>
	        % endif

	        % if error_messages or log:
                <ul class="nav nav-tabs">
                    <li class="active">
                        <a href="#queryPane" data-toggle="tab">Query</a>
                    </li>
                    % if error_message or log:
                      <li>
                        <a href="#errorPane" data-toggle="tab">
                        % if log:
                            Error Log
                        % else:
                            &nbsp;
                        % endif
                        </a>
                    </li>
                    % endif
                </ul>

				<div class="tab-content">
					<div class="active tab-pane" id="queryPane">
						${query()}
					</div>
					% if error_message or log:
						<div class="tab-pane" id="errorPane">
						% if log:
							<pre>${log | h}</pre>
						% endif
						</div>
					% endif
				</div>
			% else:
				${query()}
			% endif
			<br/>
		</div>
	</div>
</div>





<div id="chooseFile" class="modal hide fade">
	<div class="modal-header">
		<a href="#" class="close" data-dismiss="modal">&times;</a>
		<h3>Choose a file</h3>
	</div>
	<div class="modal-body">
		<div id="filechooser">
		</div>
	</div>
	<div class="modal-footer">
	</div>
</div>

<style>
	#filechooser {
		min-height:100px;
		overflow-y:scroll;
	}
</style>


<script type="text/javascript" charset="utf-8">
	$(document).ready(function(){
		$("*[rel=popover]").popover({
			offset: 10
		});
		// hack!!!
		$("select").addClass("span3");

		$("a[data-form-prefix]").each(function(){
			var _prefix = $(this).attr("data-form-prefix");
			var _nextID = 0;
			if ($("."+_prefix+"Field").length){
				_nextID= ($("."+_prefix+"Field").last().attr("name").substr(_prefix.length+1).split("-")[0]*1)+1;
			}
			$("<input>").attr("type","hidden").attr("name",_prefix+"-next_form_id").attr("value",_nextID).appendTo($("#advancedSettingsForm"));
			$("."+_prefix+"Delete").click(function(e){
				e.preventDefault();
				$("input[name="+_prefix+"-add]").attr("value","");
				$("<input>").attr("type","hidden").attr("name", $(this).attr("name")).attr("value","True").appendTo($("#advancedSettingsForm"));
				checkAndSubmit();
			});
		});

		$("a[data-form-prefix]").click(function(){
			var _prefix = $(this).attr("data-form-prefix");
			$("<input>").attr("type","hidden").attr("name",_prefix+"-add").attr("value","True").appendTo($("#advancedSettingsForm"));
			checkAndSubmit();
		});

		$("a[data-filechooser-destination]").click(function(){
			var _destination = $(this).attr("data-filechooser-destination");
			$("#filechooser").jHueFileChooser({
				onFileChoose: function(filePath){
					$("input[name='"+_destination+"']").val(filePath);
					$("#chooseFile").modal("hide");
				},
				createFolder: false
			});
			$("#chooseFile").modal("show");
		});

		$("#executeQuery").click(function(){
			$("<input>").attr("type","hidden").attr("name","button-submit").attr("value","Execute").appendTo($("#advancedSettingsForm"));
			checkAndSubmit();
		});

		$("#saveQuery").click(function(){
			$("<input>").attr("type","hidden").attr("name","saveform-save").attr("value","Save").appendTo($("#advancedSettingsForm"));
			checkAndSubmit();
		});

		$("#saveQueryAs").click(function(){
			$("<input>").attr("type","hidden").attr("name","saveform-saveas").attr("value","Save As...").appendTo($("#advancedSettingsForm"));
			checkAndSubmit();
		});

		$("#explainQuery").click(function(){
			$("<input>").attr("type","hidden").attr("name","button-explain").attr("value","Explain").appendTo($("#advancedSettingsForm"));
			checkAndSubmit();
		});

		$("#queryField").change(function(){
			$(".query").val($(this).val());
		});

		$("#queryField").focus(function(){
			$(this).removeClass("fieldError");
			$("#validationResults").empty();
		});

		function checkAndSubmit(){
			// TODO: client side validation
			$(".query").val($("#queryField").val());
			$("#advancedSettingsForm").submit();
		}


	});
</script>


${commonfooter()}
