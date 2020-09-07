import { Presence } from 'phoenix'
import Player from './player'

let Video = {
    presence: null,
    init(socket, element) {
        if (!element) { return }
        let playerId = element.getAttribute('data-player-id')
        let videoId = element.getAttribute('data-id')
        socket.connect()
        Player.init(element.id, playerId, () => {
            this.onReady(videoId, socket)
        })
    },
    onReady(videoId, socket) {
        let msgContainer = document.getElementById('msg-container')
        let msgInput = document.getElementById('msg-input')
        let postButton = document.getElementById('msg-submit')
        let userList = document.getElementById('user-list')
        let lastSeenId = 0
        let vidChannel = socket.channel(`videos:${videoId}`, () => ({ last_seen_id: lastSeenId }))

        this.presence = new Presence(vidChannel)  

        this.presence.onSync(() => { 
            userList.innerHTML = this.presence.list((id, {user, metas: [, ...rest]}) => {
                let count = rest.length + 1
                return `<li>${user.username}: (${count})</li>`
            }).join("")
        })

        postButton.addEventListener('click', (e) => {
            let payload = { body: msgInput.value, at: Player.getCurrentTime() }
            vidChannel
                .push('new_annotation', payload)
                .receive('error', e => console.log(e))
            msgInput.value = ''
        })

        vidChannel.on('new_annotation', res => {
            lastSeenId = res.id
            this.renderAnnotation(msgContainer, res)
        })

        msgContainer.addEventListener('click', e => {
            e.preventDefault()
            let millis = e.target.getAttribute('data-seek') 
                || e.target.parentNode.getAttribute('data-seek')
            if (!millis) { return }
            Player.seekTo(millis)
        })

        vidChannel.join()
            .receive('ok', res => {
                console.log('joined video channel', res)
                let ids = res.annotations.map(a => a.id)
                if (ids.length) { lastSeenId = Math.max(...ids) }
                this.scheduleMessages(msgContainer, res.annotations)
            })
            .receive('error', reason => console.log('join failed', reason))
    },
    esc(str) {
        let div = document.createElement('div')
        div.appendChild(document.createTextNode(str))
        return div.innerHTML
    },
    renderAnnotation(msgContainer, res) {
        let template = document.createElement('div')
        template.innerHTML = `
            <a href="#" data-seek="${this.esc(res.at)}">
                [${this.formatTime(res.at)}]
                <b>${this.esc(res.user.username)}</b>: ${this.esc(res.body)}
            </a>
        `
        msgContainer.appendChild(template)
        msgContainer.scrollTop = msgContainer.scrollHeight
    },
    scheduleMessages(msgContainer, annotations) {
        clearTimeout(this.scheduleTimer)
        this.scheduleTimer = setTimeout(() => {
            let currentTime = Player.getCurrentTime()
            let remaining = this.renderAtTime(msgContainer, annotations, currentTime)
            this.scheduleMessages(msgContainer, remaining)
        }, 1000)
    },
    renderAtTime(msgContainer, annotations, currentTime) {
        return annotations.filter(a => {
            if(a.at > currentTime) { return true }
            this.renderAnnotation(msgContainer, a)
            return false
        })
    },
    formatTime(at) {
        let date = new Date(null)
        date.setSeconds(at / 1000)
        return date.toISOString().substr(14, 5)
    }
}

export default Video