local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt

return {
  -- React Functional Component
  s(
    'rfc',
    fmt(
      [[
    import React from 'react';

    const {} = () => {{
      return (
        <div>{}</div>
      );
    }};

    export default {};
  ]],
      {
        i(1, 'ComponentName'),
        i(2, 'ComponentName'),
        i(3, 'ComponentName'),
      }
    )
  ),

  -- useState Hook
  s(
    'us',
    fmt([[const [{}, set{}] = useState({});]], {
      i(1, 'value'),
      c(2, { i(nil, 'Value'), i(nil, 'value[0]:upper()') }), -- manual uppercase if wanted
      i(3, 'initialValue'),
    })
  ),

  -- useEffect Hook
  s(
    'ue',
    fmt(
      [[
    useEffect(() => {{
      {}
    }}, [{}]);
  ]],
      {
        i(1, '// effect'),
        i(2, ''),
      }
    )
  ),
}
