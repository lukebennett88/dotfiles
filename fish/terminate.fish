function terminate
  lsof -ti:$argv | xargs kill
end
