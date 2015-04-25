Template['detail'].helpers {

  _homework:->
      Session.get('_homework')
      
  attachment: ->
    homework = Session.get('_homework')
    flag = 0
    pattern = /[a-zA-Z0-9]+/
    name = $( '#login-name-link').text! - '▾'
    name = pattern.exec(name)[0]
    if homework then
      length = homework['attachment'].length
      if length != 0
        for i to length - 1
          temp = homework['attachment'][i]
          if temp.name && temp.name == name
            return temp
      if flag == 1 || length == 0
        return {}
        
  attachments: ->
    homework = Session.get('_homework')
    homework['attachment']
    
}
Template['detail'].events {

  'click .return' : !->
    ($ '.main .container').slideToggle!
    ($ '#detail').slideToggle!
    
  'click .button.submit_content': (ev, tpl)-> 
    ev.prevent-default!
    if $ 'form[data-parsley-validate]' .parsley!validate!
      id = ($ 'input[name=_id]').val!
      title = ($ '.title').html!
      content = ($ 'input[name=content]').val!
      pattern = /[a-zA-Z0-9]+/
      name = $( '#login-name-link').text! - '▾'
      name = pattern.exec(name)[0]
      flag = 0
      
      attachment = {'name':name, 'title':title, 'content':content, 'date': new Date!, 'remark': '未评分'}
      
      homework = Homeworks.findOne $or: [{title}]
      
      if homework then
        console.log homework
        length = homework['attachment'].length
        deadline = homework['date'].valueOf!
        current = new Date!.valueOf!
        
        if deadline > current
          console.log length
          if length != 0
            
            for i to length - 1
              temp = homework['attachment'][i]
              if temp.name && temp.name == name
                temp.content = content
                temp.date = new Date!
                flag := 1
                [Homeworks.update {'_id': id}, $set: attachment : homework['attachment']]
          if flag == 0
            homework['attachment'].push attachment
            [Homeworks.update {'_id': id}, $set: attachment : homework['attachment']]
        else alert '超过时间限制，不可提交'
        
      else
        console.log Homeworks.findOne $or: [{title}]
        
  'click .button.submit_remark': (ev, tpl)-> 
    ev.prevent-default!
    value = ($ ev)[0].currentTarget.previousElementSibling.firstChild.value
    title = this.title
    name = this.name
    id = ($ 'dl').attr('id')
    homework = Homeworks.findOne $or: [{title}]
    if homework then
      length = homework['attachment'].length
      if length != 0
        for i to length - 1
          temp = homework['attachment'][i]
          if temp.name && temp.name == name
            temp.remark = value
            [Homeworks.update {'_id': id}, $set: attachment : homework['attachment']]
  'click .button.submit_modify': (ev, tpl)->
    ($ '#detail').hide!
    ($ '#modify-homework').show!
    title = ($ '#detail h1.title').html!
    date = ($ '#detail .date small').html!
    description = ($ 'dt.description').html!
    ($ '#modify-homework input[name=title_modify]').val(title)
    ($ '#modify-homework textarea[name=description_modify]').val(description)
}
