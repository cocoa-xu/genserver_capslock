const SharedState = {
  capsLockOn: false
}

let Hooks = {
  CapsLock: {
    mounted() {
      window.addEventListener('keydown', e => {
        if (e.key === "CapsLock") {
          this.pushEvent("capslock_change", {})
        }
      })
  
      this.handleEvent("capslock_change", ({capslock}) => {
        SharedState.capsLockOn = capslock
        if (capslock) {
          document.title = "GENSERVER CAPSLOCK"
          document.getElementById("caps-status").innerText = "Yes";
          document.querySelectorAll('[data-capslock="yes"]').forEach(el => {
            el.classList.add("capslock")
          })
        } else {
          document.title = "GenServer Capslock"
          document.getElementById("caps-status").innerText = "No";
          document.querySelectorAll('[data-capslock="yes"]').forEach(el => {
            el.classList.remove("capslock")
          })
        }
      })

      this.handleEvent("user_count", ({user_count}) => {
        document.getElementById("user-count").innerText = user_count
      })
    }
  },
  TextareaListener: {
    mounted() {
      this.el.addEventListener('input', e => {
        const text = e.target.value
        const pos = e.target.selectionStart
        
        // Get the last character typed
        const lastChar = text.charAt(pos - 1)
        
        if (lastChar && lastChar.match(/[a-zA-Z]/)) {
          // Create new text with case changed based on capslock
          const newText = text.slice(0, pos - 1) + 
            (SharedState.capsLockOn ? lastChar.toUpperCase() : lastChar.toLowerCase()) +
            text.slice(pos)
            
          // Update textarea value and maintain cursor position
          e.target.value = newText
          e.target.setSelectionRange(pos, pos)
        }
      })
    }
  }
}

export default Hooks;
