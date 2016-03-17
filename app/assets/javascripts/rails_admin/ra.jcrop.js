(function($) {
  $.widget("ra.jcropForm", {

    _create: function() {
      var widget = this;
      var dom_widget = widget.element;

      var thumbnailLink = dom_widget.find('.toggle a[target="_blank"]');
      thumbnailLink.unbind().bind("click", function(e){
        widget._bindModalOpening(e, dom_widget.find('a.jcrop_handle').data('link'));
        return false;
      });
    },

    _bindModalOpening: function(e, url) {
      e.preventDefault();
      widget = this;
      if($("#modal").length)
        return false;

      var dialog = this._getModal();

      setTimeout(function(){ // fix race condition with modal insertion in the dom (Chrome => Team/add a new fan => #modal not found when it should have). Somehow .on('show') is too early, tried it too.
        $.ajax({
          url: url,
          beforeSend: function(xhr) {
            xhr.setRequestHeader("Accept", "text/javascript");
          },
          success: function(data, status, xhr) {
              dialog.find('.modal-body').html(data);
              widget._bindFormEvents();
          },
          error: function(xhr, status, error) {
            dialog.find('.modal-body').html(xhr.responseText);
          },
          dataType: 'text'
        });
      },100);

    },

    _bindFormEvents: function() {
      var widget = this,
          dialog = this._getModal(),
          form = dialog.find("form"),
          saveButtonText = dialog.find(":submit[name=_save]").html(),
          cancelButtonText = dialog.find(":submit[name=_continue]").html();
      dialog.find('.form-actions').remove();

      var jcrop_options = $.extend({
        bgColor: 'white',
        keySupport: false,
        onSelect: widget.updateCoordinates
      }, rails_admin_jcrop_options);
      dialog.find('img.jcrop-subject').Jcrop(jcrop_options)

      form.attr("data-remote", true);
      dialog.find('.modal-header .modal-title').text(form.data('title'));
      dialog.find('.cancel-action').unbind().click(function(){
        dialog.modal('hide');
        return false;
      }).html(cancelButtonText);

      dialog.find('.save-action').unbind().click(function(){
        $(this).addClass('disabled');
        form.submit();
        return false;
      }).html(saveButtonText);

      $(document).trigger('rails_admin.dom_ready');

      form.bind("ajax:complete", function(xhr, data, status) {
        if (status == 'error') {
          dialog.find('.modal-body').html(data.responseText);
          widget._bindFormEvents();
        } else {
          var json = $.parseJSON(data.responseText);
          var select = widget.element.find('select').filter(":hidden");

          thumb = widget.element.find('a.jcrop_handle').data('thumb');
          widget.element.find('img.img-polaroid').removeAttr('src').attr('src', json.urls[thumb] + '?' + new Date().valueOf());

          widget._trigger("success");
          dialog.modal("hide");
        }
      });
    },

    updateCoordinates: function(c) {
      var rx = 100/c.w;
      var ry = 100/c.h;
      var lw = $('img.jcrop-subject').width();
      var lh = $('img.jcrop-subject').height();
      var ratio = $('img.jcrop-subject').data('geometry').split(',')[0] / lw ;

      $('#preview').css({
        width: Math.round(rx * lw) + 'px',
        height: Math.round(ry * lh) + 'px',
        marginLeft: '-' + Math.round(rx * c.x) + 'px',
        marginTop: '-' + Math.round(ry * c.y) + 'px'
      });

      $("#crop_x").val(Math.round(c.x * ratio));
      $("#crop_y").val(Math.round(c.y * ratio));
      $("#crop_w").val(Math.round(c.w * ratio));
      $("#crop_h").val(Math.round(c.h * ratio));
    },

    _getModal: function() {
      var widget = this;
      if (!widget.dialog) {
          //widget.dialog = $('<div id="modal" class="modal fade"><div class="modal-dialog modal-lg"><div class="modal-content"><div class="modal-header"><a href="#" class="close" data-dismiss="modal">&times;</a><h3 class="modal-header-title">...</h3></div><div class="modal-body">...</div><div class="modal-footer"><a href="#" class="btn cancel-action">...</a><a href="#" class="btn btn-primary save-action">...</a></div></div></div></div>');
          widget.dialog = $('<div class="modal fade" tabindex="-1" role="dialog"> <div class="modal-dialog ra-jcrop"> <div class="modal-content"> <div class="modal-header"> <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button> <h4 class="modal-title">...</h4> </div><div class="modal-body">...</div><div class="modal-footer"> <button type="button" class="btn btn-primary save-action">...</button> <button type="button" class="btn btn-default cancel-action" data-dismiss="modal">...</button> </div></div></div></div>')
          widget.dialog.modal({
            keyboard: true,
            backdrop: true,
            show: true
          })
          .on('hidden.bs.modal', function(){
            widget.dialog.remove();   // We don't want to reuse closed modals
            widget.dialog = null;
          });
        }
      return this.dialog;
    }
  });
})(jQuery);

$(function() {
  $('div.jcrop_type').jcropForm();
});
