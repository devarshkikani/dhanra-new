# Dart MCP Server Setup

The **Model Context Protocol (MCP)** server for Dart enables AI assistants (Antigravity, Claude Code, Cursor) to interact directly with the Dart analyzer, run tests, and inspect code structure.

## Configuration

The MCP configuration file is located at [.mcp/mcp.json](file:///Users/don-devarsh/Documents/Demo/flutter-ai-setup/.mcp/mcp.json):

```json
{
  "mcpServers": {
    "dart-flutter": {
      "command": "dart",
      "args": ["mcp-server"]
    }
  }
}
```

## How to Enable in AI Clients
- **Antigravity / Gemini CLI**: The server automatically detects `.mcp/mcp.json`.
- **Cursor / Claude Desktop**: Copy the JSON snippet into your global or project `mcp.json` settings file.
- **Verification**: Run `dart mcp-server --help` in your terminal to verify availability.
