export const Notify = async ({ $ }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        await $`notify-send "OpenCode" "Waiting for your prompt"`
      }
    },
  }
}
