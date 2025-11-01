# LibreChat Productivity Agent - Setup Guide

## Quick Start

This guide will help you set up your Personal Productivity Assistant agent in LibreChat using the provided configuration file.

---

## Option 1: Manual Setup (Recommended)

Since LibreChat may not support direct JSON import for agents, follow these steps to create the agent manually:

### 1. Access Agent Builder

1. Open LibreChat: http://localhost:3080
2. Click the **endpoint dropdown** (top left)
3. Select **"Agents"**
4. Click the **side panel icon** (right side) to open Agent Builder
5. Click **"+ Create Agent"** or **"New Agent"**

### 2. Basic Configuration

Fill in the form with these details:

**Name:**
```
Personal Productivity Assistant
```

**Description:**
```
AI agent that manages tasks in Todoist and processes Gmail inbox for maximum productivity
```

**Avatar:**
- Choose any productivity-themed icon or upload a custom one

### 3. Instructions (System Prompt)

Copy the entire "instructions" field from `productivity-agent-config.json` and paste it into the Instructions box.

**Or copy from here:**

Open the file:
```bash
cat /Users/daviddiviny/Developer/Divad/LibreChat/productivity-agent-config.json
```

Copy everything between the "instructions" quotes.

### 4. Model Selection

**Provider:** Select "Divad" (your custom Claude endpoint)
**Model:** claude-sonnet-4-5
**Temperature:** 0.7
**Max Tokens:** 4096
**Top P:** 0.95

### 5. Add Tools

In the Agent Builder:

1. Click **"Add Tools"** button
2. Find and enable:
   - ✅ **todoist** (8 tools)
   - ✅ **gmail** (19 tools)

These tools will now be automatically available every time you use this agent.

### 6. Save Agent

Click **"Save"** or **"Create Agent"** button.

---

## Option 2: Copy-Paste Configuration (If Import Available)

If LibreChat supports agent import:

1. Go to Agent Builder
2. Look for **"Import"** or **"Upload"** button
3. Select: `/Users/daviddiviny/Developer/Divad/LibreChat/productivity-agent-config.json`
4. Review imported settings
5. Save

---

## Using Your Agent

### Starting a Conversation

1. Select **"Agents"** endpoint
2. Choose **"Personal Productivity Assistant"** from the agent dropdown
3. Start chatting!

### Example Commands

**Daily Briefing:**
```
What do I need to do today?
Give me my morning briefing
Show me urgent items
```

**Email Triage:**
```
Process my inbox
Show me unread emails from today
Search emails from Sarah about the proposal
Create tasks from my recent emails
```

**Task Management:**
```
What tasks are due today?
Show me overdue tasks
Create a task to follow up on the meeting
Mark "Review proposal" as complete
```

**Cross-Tool Workflows:**
```
Find the email about X and create a task
Show me tasks related to recent emails
Create a follow-up reminder for the email I sent to John
```

**End of Day:**
```
Give me an end-of-day summary
What did I accomplish today?
What should I prioritize tomorrow?
```

---

## Customization Tips

### Adjusting the Personality

Edit the Instructions to make the agent more/less:

**More Formal:**
- Change "Let's" → "We should"
- Remove casual phrases
- Add professional greetings

**More Casual:**
- Add friendly language
- Use first person ("I'll help you...")
- Add encouraging phrases

### Adding Domain-Specific Knowledge

Add custom instructions for your workflow:

```markdown
## Work Context
- I work in software development
- My team uses Linear for project tracking
- Important contacts: Sarah (manager), John (client)
- Daily standup at 9 AM

## Personal Preferences
- Prefer morning for deep work
- Check email at 9 AM and 3 PM only
- Flag anything from clients as P1
```

### Adjusting Proactivity

**More Proactive:**
- Lower temperature to 0.5
- Add "Always suggest next steps" to instructions

**Less Proactive:**
- Raise temperature to 0.9
- Add "Only suggest when asked" to instructions

---

## Troubleshooting

### Tools Not Appearing

If Todoist or Gmail tools don't show up:

1. Check MCP servers are running:
   ```bash
   docker logs LibreChat 2>&1 | grep -i "mcp.*initialized"
   ```

2. Verify tools in dropdown (outside agent):
   - Create a normal chat
   - Look for tool dropdown near input
   - Both should appear there

3. Restart LibreChat:
   ```bash
   cd /Users/daviddiviny/Developer/Divad/LibreChat
   docker-compose restart api
   ```

### Agent Not Following Instructions

**Try:**
- Make instructions more explicit
- Add examples in the prompt
- Reduce temperature to 0.5
- Break complex instructions into numbered lists

### Token Limit Errors

If you hit token limits:

1. Increase max_tokens to 8192
2. Shorten the instruction prompt
3. Ask more focused questions

### Agent Too Verbose

**Solutions:**
- Add "Be concise" to instructions
- Lower max_tokens to 2048
- Add "Use bullet points" preference

---

## Advanced: Creating Variations

### Email-Only Agent

Create a second agent:
- Name: "Email Manager"
- Tools: Gmail only
- Instructions: Focus on email triage
- Use case: Quick email checks

### Task-Only Agent

Create a third agent:
- Name: "Task Manager"
- Tools: Todoist only
- Instructions: Focus on task planning
- Use case: Weekly planning sessions

### Agent Chain

Use multiple agents together:
1. Email Manager → Processes inbox
2. Task Manager → Creates tasks from output
3. Productivity Assistant → Coordinates both

---

## Testing Checklist

Before regular use, test:

- [ ] Daily briefing generates correctly
- [ ] Can search Gmail for specific emails
- [ ] Can create Todoist tasks with dates
- [ ] Can link emails to tasks
- [ ] Suggests priorities appropriately
- [ ] Handles errors gracefully
- [ ] Respects privacy (doesn't share sensitive data)
- [ ] Works with your actual email/task data

---

## Maintenance

### Weekly Review

Every week:
1. Review agent conversations
2. Note repeated issues
3. Update instructions to address them
4. Test new edge cases

### Version Control

Save instruction versions:
1. Keep `productivity-agent-config.json` updated
2. Create dated backups before major changes
3. Document what changed and why

---

## Support & Resources

**LibreChat Documentation:**
- Agents: https://www.librechat.ai/docs/features/agents
- MCP: https://www.librechat.ai/docs/features/mcp

**Your Setup:**
- Config file: `/Users/daviddiviny/Developer/Divad/LibreChat/productivity-agent-config.json`
- System prompt: `/Users/daviddiviny/Developer/Divad/LibreChat/productivity-agent-prompt.md`
- LibreChat: http://localhost:3080

**Getting Help:**
- LibreChat GitHub: https://github.com/danny-avila/LibreChat
- LibreChat Discord: https://discord.librechat.ai

---

## Next Steps

1. ✅ Create the agent in LibreChat
2. ✅ Test with example commands
3. ✅ Customize instructions for your workflow
4. ✅ Use daily for 1 week
5. ✅ Iterate based on feedback
6. 🔄 Create specialized agent variations
7. 🔄 Set up Agent Chains for complex workflows

Happy productivity! 🚀
