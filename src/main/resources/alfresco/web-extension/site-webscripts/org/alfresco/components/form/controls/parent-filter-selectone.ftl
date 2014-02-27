<#include "/org/alfresco/components/form/controls/common/utils.inc.ftl" />

<#if field.control.params.optionSeparator??>
   <#assign optionSeparator=field.control.params.optionSeparator>
<#else>
   <#assign optionSeparator=",">
</#if>
<#if field.control.params.labelSeparator??>
   <#assign labelSeparator=field.control.params.labelSeparator>
<#else>
   <#assign labelSeparator="|">
</#if>

<#assign fieldValue=field.value>

<#if fieldValue?string == "" && field.control.params.defaultValueContextProperty??>
   <#if context.properties[field.control.params.defaultValueContextProperty]??>
      <#assign fieldValue = context.properties[field.control.params.defaultValueContextProperty]>
   <#elseif args[field.control.params.defaultValueContextProperty]??>
      <#assign fieldValue = args[field.control.params.defaultValueContextProperty]>
   </#if>
</#if>
<#if form.mode != "view">
   <script type="text/javascript">
      var GROUP_LABEL_SEPARATOR = " - ";
      <#list field.control.params.filteredProperty?split(",") as filtProp>
         var allPropertyOptions${filtProp} = [];
      </#list>
         
      function getElementsByStartId( idStartName, obj ) {
          var ar = arguments[2] || new Array();
      
          if (obj.id&&obj.id.indexOf(idStartName) != -1) {
              ar.push( obj );
          }
          for ( var i = 0, max = obj.childNodes.length; i < max; i++ )
              getElementsByStartId( idStartName, obj.childNodes[i], ar );
          
          return ar;
      }
      
      function getGroupNumbers(itemField){
         return itemField.value.split(GROUP_LABEL_SEPARATOR)[0];
      }
      
      function belongsItemToGroup(itemField,groupNumber){
         var groupList = getGroupNumbers(itemField).split("."),
            belongs = false;
            
         for (var i=0, max=groupList.length; i < max && !belongs; i++) {
            belongs = (groupList[i] === groupNumber);
         }
         
         return belongs;
      }
      
      function selectivelyEnablePropertyField(groupNumber, propertyName, optionsList) {
         var propertyField = getPropertySelectField(propertyName);
         removeAllPropertyFieldOptions(propertyName);
         propertyField.disabled = false;
         for(var i=0, max = optionsList.length; i < max; i++){
            if(optionsList[i].value == "" || belongsItemToGroup(optionsList[i], groupNumber) ) {
               propertyField.add(optionsList[i], null);
            }
         }
         if(!propertyField.selectedIndex || propertyField.selectedIndex < 0)
            propertyField.selectedIndex = 0;
      }
      
      function removeAllPropertyFieldOptions(propertyName) {
         var propertyField = getPropertySelectField(propertyName);
         for(var i = propertyField.options.length; i>0; i--){
            propertyField.remove(i-1);
         }
      }
      
      function disablePropertyField(propertyName) {
         removeAllPropertyFieldOptions(propertyName);
         getPropertySelectField(propertyName).disabled = true;
      }
      
      function getPropertySelectField(propName) {
         return document.getElementById("${args.htmlid}_prop_" + propName);
      }
      
      function initPropertyFieldList(propertyName, propertyOptionsList) {
         if (propertyOptionsList.length == 0) {
            var propertyField = getPropertySelectField(propertyName);
            for (var i = 0, max = propertyField.options.length;i < max; i++) {
               propertyOptionsList.push(propertyField.options[i]);
            }
         }
      }
      
      function updateChanges${field.name?substring(5)}() {
         var parentNumber = getGroupNumbers(document.getElementById("${fieldHtmlId}").options[document.getElementById("${fieldHtmlId}").selectedIndex]);
         var propertyList = ("${field.control.params.filteredProperty}").split(",");
         
         for (var i=0, max=propertyList.length; i < max; i++) {
            var propertyOptions = eval(("allPropertyOptions").concat(propertyList[i]));
            initPropertyFieldList(propertyList[i], propertyOptions);
      
            if (parentNumber != "") {
               selectivelyEnablePropertyField(parentNumber, propertyList[i], propertyOptions);
            } else {
               disablePropertyField(propertyList[i]);
            }
         }
            
         return false;
      }
      
      setTimeout("updateChanges${field.name?substring(5)}()", 50);
   </script>
</#if>
<div class="form-field">
   <#if form.mode == "view">
      <div class="viewmode-field">
         <#if field.mandatory && !(fieldValue?is_number) && fieldValue?string == "">
            <span class="incomplete-warning"><img src="${url.context}/res/components/form/images/warning-16.png" title="${msg("form.field.incomplete")}" /><span>
         </#if>
         <span class="viewmode-label">${field.label?html}:</span>
         <#if fieldValue?string == "">
            <#assign valueToShow=msg("form.control.novalue")>
         <#else>
            <#assign valueToShow=fieldValue>
            <#if field.control.params.options?? && field.control.params.options != "">
               <#list field.control.params.options?split(optionSeparator) as nameValue>
                  <#if nameValue?index_of(labelSeparator) == -1>
                     <#if nameValue == fieldValue?string || (fieldValue?is_number && fieldValue?c == nameValue)>
                        <#assign valueToShow=nameValue>
                        <#break>
                     </#if>
                  <#else>
                     <#assign choice=nameValue?split(labelSeparator)>
                     <#if choice[0] == fieldValue?string || (fieldValue?is_number && fieldValue?c == choice[0])>
                        <#assign valueToShow=msgValue(choice[1])>
                        <#break>
                     </#if>
                  </#if>
               </#list>
            </#if>
         </#if>
         <#assign splittedNamedValue=valueToShow?html?split(" - ")>
         <span class="viewmode-value">
            <#if splittedNamedValue[1]??>${splittedNamedValue[1]}<#else>none</#if>
         </span>
      </div>
   <#else>
      <label for="${fieldHtmlId}">${field.label?html}:<#if field.mandatory><span class="mandatory-indicator">${msg("form.required.fields.marker")}</span></#if></label>
      <#if field.control.params.options?? && field.control.params.options != "">
         <select id="${fieldHtmlId}" name="${field.name}" tabindex="0" onchange="updateChanges${field.name?substring(5)}();"
               <#if field.description??>title="${field.description}"</#if>
               <#if field.control.params.size??>size="${field.control.params.size}"</#if> 
               <#if field.control.params.styleClass??>class="${field.control.params.styleClass}"</#if>
               <#if field.control.params.style??>style="${field.control.params.style}"</#if>
               <#if field.disabled  && !(field.control.params.forceEditable?? && field.control.params.forceEditable == "true")>disabled="true"</#if>>
               <#list field.control.params.options?split(optionSeparator) as nameValue>
                  <option value="${nameValue?html?split("|")[0]}"<#if nameValue?split("|")[0] == fieldValue?string || (fieldValue?is_number && fieldValue?c == nameValue?split("|")[0])> selected="selected"</#if>>
                     <#if nameValue?index_of(" - ") != -1>
                        ${nameValue?split(" - ")[1]?split("|")[0]}
                     </#if>
                  </option>
               </#list>
         </select>
         <@formLib.renderFieldHelp field=field />
      <#else>
         <div id="${fieldHtmlId}" class="missing-options">${msg("form.control.selectone.missing-options")}</div>
      </#if>
   </#if>
</div>