$(document).on 'turbolinks:load', ->
  # $('#uploadBtn').on 'change', (e) ->
  #   $('#uploadFile').attr('value', this.value)

  $('#photo_upload input[type=file]').on 'change', (e) ->
    reader = new FileReader

    reader.onload = (readerEvent) ->
      $('#photo-gallery-modal .swiper-wrapper').append(
        HandlebarsTemplates['gallery_entry'](
          imageUrl: readerEvent.target.result
        )
      )
      $('#photo_list').append(
        HandlebarsTemplates['photo'](
          imageUrl: readerEvent.target.result
        )
      )

    reader.readAsDataURL e.target.files[0]
    return


  $('#photo-gallery-modal').on 'shown.bs.modal', ->
    coolio = new Swiper '#photo-gallery-modal .swiper-container',
      nextButton: '#photo-gallery-modal .swiper-button-next'
      prevButton: '#photo-gallery-modal .swiper-button-prev'
      preloadImages: false
      lazyLoading: true
      setWrapperSize: true
      keyboardControl: true
      observer: true
      loop: true
      scrollbarDraggable: true
      scrollbar: '.swiper-scrollbar'

  $('#photo_upload form').fileupload
    url: '/photos.json'
    type: 'POST'
    dataType: 'json'
    add: (e, data) ->
      console.log("Add")
      data.files.forEach (file) ->
        file.uploadId = Math.random().toString()
        $('#upload-list').append(
          HandlebarsTemplates['file_upload'](
            percentComplete: 0
            fileName: file.name
            uploadId: file.uploadId
          )
        )
      if data.autoUpload or data.autoUpload != false and $(this).fileupload('option', 'autoUpload')
        data.process().done ->
          data.submit()
          return
      return

    done: (e, data) ->
      uploadId = data.files[0].uploadId
      $('#upload-list div[data-upload-id=\'' + uploadId + '\']').remove()

    fail: (e, data) ->
      bootbox.alert 'There was an error uploading ' + data.files[0].name + '. Please try again.', ->
        uploadId = data.files[0].uploadId
        $('#upload-list div[data-upload-id=\'' + uploadId + '\']').remove()
        $('#photo_list div:last-child').remove()

    progress: (e, data) ->
      uploadId = data.files[0].uploadId
      # fileName = data.flavor1Files[0].name
      progress = parseInt(data.loaded / data.total * 100, 10)
      $('#upload-list div[data-upload-id=\'' + uploadId + '\'] progress').attr('value', progress)
